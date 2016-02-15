UserDropdown = () ->
  restrict: 'A'
  template: JST['directives/user_dropdown/user_dropdown_directive_template']
  controllerAs: 'userDrop'
  controller: ['$window', 'User', ($window, User) ->
    @name = ''

    User.me( (response) =>
      @showUser = true
      @user = response.data.user
      @name = setName()
    , (err) =>
      @showUser = false
      console.log(err)
    )

    setName = =>
      if @user.current_content_owner
        @user.current_content_owner.name
      else
        @user.name

    @logout = (e) ->
      User.logout( (response) =>
        $window.location.reload()
      , (err) =>
        console.log("Error logging out")
      )

    @updateCms = (contentOwner) =>
      User.update( @user.id, {content_owner_id: contentOwner.id}, =>
        $window.location.reload()
      , (err) =>
        console.log("Error logging out")
      )

    return
  ]

angular
  .module('Videotelligent')
  .directive('userDropdown', [UserDropdown])
