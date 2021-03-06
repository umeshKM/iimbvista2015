class RegistrationsController < ApplicationController
  def register
  	@message=""
  	event_id=params[:event_id]
  	event=Event.find_by_id(event_id)
  	team_list=[]
  	registrations=params[:register]
  	team_name=params[:team_name]
    registrations={} unless registrations
  	registrations.each do |k,v|
  		if v[:email].present? && v[:phone].present?
  			user=User.find_or_create_by_email(v[:email])
  			if user.new_record?
  				user.update_attribute(:full_name, v[:email])
  				user.update_attribute(:phone, v[:phone])
          user.update_attribute(:college_id, current_user.college_id)
  				user.password="welcome2vista2015"
  				user.password_confirmation="welcome2vista2015"
  				user.save!
  			end
  			user.reload
  			team_list<<user if !team_list.include?(user)
  		end
  	end
 	  check_team=event.teams.collect(&:name).include?(team_name)
 	  if check_team
 		 @message="Same Team name already exists"
 	  elsif team_list.count >= event.min_per_team
  		team=Team.create({event_id: event.id, name: team_name})
  		team.users=team_list
  		team.save!
      team.send_event_reg_mails
  	else
  		@message="Did not meet the minimum criteria"
  	end
    flash[:error]=@message
    redirect_to :back
  end
end
