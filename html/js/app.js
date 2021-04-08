$(function () {
    toastr.options = {
        closeButton: false,
        debug: false,
        newestOnTop: false,
        progressBar: true,
        positionClass: "toast-top-right",
        preventDuplicates: true,
        onclick: null,
        showDuration: 300,
        hideDuration: 1000,
        timeOut: 4000,
        extendedTimeOut: 1000,
        showEasing: "swing",
        hideEasing: "linear",
        showMethod: "fadeIn",
        hideMethod: "fadeOut"
    }

    var currentSound = null

    $('.loading-menu').fadeOut(0)

    var canSelectOne = true
    var characterSelected = 0
    var sex = 1// 0 FEMALE | 1 MALE
    var dateOfBirth = "25-08-2000"
    var acceptTerms = false
    var settings = null

    NECharacter = {};

    NECharacter.EmotionalText = [
        "When your values are clear, making decisions becomes easier",
        "Let your decisions reflect your hopes, not your fears",
        "I am not a product of my circumstances, I am a product of my decisions",
        "Sometimes the worst decisions turn into the best stories."
    ]

    NECharacter.ShowUI = function (data) {
        $('.main-menu').css({ "display": "inline" });
        var rndEmotionalText = NECharacter.EmotionalText[Math.floor(Math.random() * NECharacter.EmotionalText.length)]
        settings = data.characters

        $('.emotionalText').html(rndEmotionalText)
        $('.main-container').fadeIn(2500)

        NECharacter.SetupMainTitle()

    };

    NECharacter.SetupMainTitle = function () {

        $('.characters-list').html('')
        if (settings !== null) {
            if (settings.group == "group") {
                $('.isAdmin').fadeIn(1000);
            }

            let className = "col"
            if (settings.unlocked == 0 || settings.unlocked == 1 || settings.unlocked == 4) {
                className = "col-4"
            }

            if (settings.characters.length == 0) {
                $('.characters-list').append('<div class="' + className + ' d-xl-flex justify-content-xl-center" style="margin-bottom:5em;"> <div id="1" class="card character-box" style=" width: 340px;height: 150px;color: rgb(0, 0, 0);background: rgba(0, 0, 0, 0);border-radius: 0px;border-style: solid;border-color: rgb(0, 0, 0);"> <div class="card-body bg-hover" style=" background: rgba(0, 0, 0, 0.6); color: rgb(0, 0, 0); border-color: rgb(0, 0, 0); border-radius: 0px; " > <i class="fas fa-user-alt d-xl-flex justify-content-xl-center" style="font-size: 35px; color: rgb(255, 255, 255)" ></i> <h3 style=" text-align: center; color: rgb(255, 255, 255); margin-top: 15px; " > CREATE CHARACTER </h3><br><button onclick="NECharacter.CreateNew(1)" class="btn btn-warning btn-sm btn-outline btn-block mt-4">TO SELECT</button></div> </div> </div>');
                $('.characters-list').append('<div class="' + className + ' d-xl-flex justify-content-xl-center" style="margin-bottom:5em;"> <div id="x" class="card character-box" style=" width: 340px;height: 150px; color: rgb(0, 0, 0); background: rgba(255, 255, 255, 0); border-radius: 0px; border-style: solid; " > <div class="card-body bg-hover" style=" background: rgba(0, 0, 0, 0.6); color: rgb(0, 0, 0); border-color: rgb(255, 0, 214); " > <i class="fas fa-user-lock d-xl-flex justify-content-xl-center" style="font-size: 35px; color: rgb(255, 255, 255)" ></i> <h4 style=" text-align: center; color: rgb(255, 255, 255); margin-top: 15px; font-size: 20px; " > <span style="text-decoration: line-through" >CREATE CHARACTER</span ><br /><small class="text-warning">UNLOCK WITH VIP</small> </h4> </div> </div> </div>')
            } else {
                if (settings.unlocked == 0) {
                    let character = settings.characters[0]
                    $('.characters-list').append('<div class="' + className + ' d-xl-flex justify-content-xl-center" style="margin-bottom:5em;"> <div id="' + character.characterId + '" class="card character-box" style="width: 340px;height: 150px;color: rgb(0,0,0);background: rgba(0,0,0,0);border-radius: 0px;border-style: solid;border-color: rgb(0,0,0);"> <div class="card-body bg-hover" style="background: rgba(0,0,0,0.6);color: rgb(0,0,0);border-color: rgb(0,0,0);border-radius: 0px;"><i class="fas fa-user-alt d-xl-flex justify-content-xl-center" style="font-size: 35px;color: rgb(255,255,255);"></i> <h3 style="text-align: center;color: rgb(255,255,255);margin-top: 15px;">' + character.firstname + ' ' + character.lastname + '<br /> $' + JSON.parse(character.accounts).bank + '</h3><br><div class="row mt-2"><div class="col col-8"><button onclick="NECharacter.PlayWithHim(' + character.characterId + ')" class="btn btn-play btn-sm btn-outline btn-block">SELECT STORY</button></div><div class="col-4"><button onclick="NECharacter.Delete(' + character.characterId + ')" class="btn btn-sm btn-outline-danger btn-block">❌</button></div></div> </div> </div> </div>')
                    $('.characters-list').append('<div class="' + className + ' d-xl-flex justify-content-xl-center" style="margin-bottom:5em;"> <div id="x" class="card character-box" style=" width: 340px; height: 150px; color: rgb(0, 0, 0); background: rgba(255, 255, 255, 0); border-radius: 0px; border-style: solid; " > <div class="card-body bg-hover" style=" background: rgba(0, 0, 0, 0.6); color: rgb(0, 0, 0); border-color: rgb(255, 0, 214); " > <i class="fas fa-user-lock d-xl-flex justify-content-xl-center" style="font-size: 35px; color: rgb(255, 255, 255)" ></i> <h4 style=" text-align: center; color: rgb(255, 255, 255); margin-top: 15px; font-size: 20px; " > <span style="text-decoration: line-through" >CREATE CHARACTER</span ><br /><small class="text-warning">UNLOCK WITH VIP</small> </h4> </div> </div> </div>')
                } else {
                    for (let index = 0; index <= settings.unlocked; index++) {
                        const character = settings.characters[index];
                        if (character == null || character == undefined) {
                            $('.characters-list').append('<div class="' + className + ' d-xl-flex justify-content-xl-center" style="margin-bottom:5em;"> <div id="' + (index + 1) + '" class="card character-box" style=" width: 340px;height: 150px;color: rgb(0, 0, 0);background: rgba(0, 0, 0, 0);border-radius: 0px;border-style: solid;border-color: rgb(0, 0, 0);"> <div class="card-body bg-hover" style=" background: rgba(0, 0, 0, 0.6); color: rgb(0, 0, 0); border-color: rgb(0, 0, 0); border-radius: 0px; " > <i class="fas fa-user-alt d-xl-flex justify-content-xl-center" style="font-size: 35px; color: rgb(255, 255, 255)" ></i> <h3 style=" text-align: center; color: rgb(255, 255, 255); margin-top: 15px; " > CREATE CHARACTER </h3><br><button onclick="NECharacter.CreateNew(' + (index + 1) + ')" class="btn btn-warning btn-sm btn-outline btn-block mt-4">SELECT</button></div> </div> </div>');

                        } else {
                            $('.characters-list').append('<div class="' + className + ' d-xl-flex justify-content-xl-center" style="margin-bottom:5em;"> <div id="' + character.characterId + '" class="card character-box" style="width: 340px;height: 150px;color: rgb(0,0,0);background: rgba(0,0,0,0);border-radius: 0px;border-style: solid;border-color: rgb(0,0,0);"> <div class="card-body bg-hover" style="background: rgba(0,0,0,0.6);color: rgb(0,0,0);border-color: rgb(0,0,0);border-radius: 0px;"><i class="fas fa-user-alt d-xl-flex justify-content-xl-center" style="font-size: 35px;color: rgb(255,255,255);"></i> <h4 style="text-align: center;color: rgb(255,255,255);margin-top: 15px;">' + character.firstname + ' ' + character.lastname + '<br /> $' + JSON.parse(character.accounts).bank + '</h4><br><div class="row mt-2"><div class="col col-8"><button onclick="NECharacter.PlayWithHim(' + character.characterId + ')" class="btn btn-play btn-sm btn-outline btn-block">SELECT STORY</button></div><div class="col col-4"><button onclick="NECharacter.Delete(' + character.characterId + ')" class="btn btn-sm btn-outline-danger btn-block">❌</button></div></div></div> </div> </div> </div>')
                        }
                    }
                }
            }
        }

        $('#firstname').on('keypress', function (e) {
            if (e.which == 32) {
                return false;
            }
        });

        $('#lastname').on('keypress', function (e) {
            if (e.which == 32) {
                return false;
            }
        });

        $('#country').on('keypress', function (e) {
            if (e.which == 32) {
                return false;
            }
        });

        $('#sex_female').on('change', function () {
            if ($(this).is(':checked')) {
                sex = 0
                $('#sex_male').prop('checked', false);
            }
        });

        $('#sex_male').on('change', function () {
            if ($('#sex_female').is(':checked')) {
                sex = 1
                $('#sex_female').prop('checked', false);
            }
        });

        $(".character-box").hover(
            function () {
                $(this).css({
                    "background": "rgba(196, 56, 40,0.7)",
                    "transition": "200ms",
                });
            }, function () {
                $(this).css({
                    "background": "rgba(0,0,0,0.6)",
                    "transition": "200ms",
                });
            }
        );
    }

    NECharacter.ConfirmCreation = function () {
        var firstname = $('#firstname').val()
        var lastname = $('#lastname').val()
        var height = $('#height').val()

        $.post('https://nex_characters/CreatingNewCharacter', JSON.stringify({
            firstname: firstname,
            lastname: lastname,
            height: height,
            dob: dateOfBirth,
            sex: sex,
            terms: acceptTerms,
            charId: characterSelected
        }));

        NECharacter.LoadingResponse('onCreateCharacter', true)
    }

    NECharacter.UpdateModalData = function () {
        $('.confirmModal').prop('disabled')
        var firstname = $('#firstname').val()
        var lastname = $('#lastname').val()
        var height = $('#height').val()
        var sexDesc = "Man"
        if (sex == 0) {
            sexDesc = "Woman"
        }

        var canContinue = false

        if ((firstname.length > 2 && lastname.length > 2) && (height.length > 1) && (dateOfBirth !== "" || dateOfBirth != " ")) {
            if (height >= 150 && height <= 200) {
                canContinue = true
            }
        }

        if (!canContinue) {
            toastr.error('You must complete all the fields.', 'Whoops!')
        } else {
            $('#terms').on('change', function () {
                if ($(this).is(':checked')) {
                    acceptTerms = true
                    $('.confirmModalBtn').removeAttr('disabled')
                } else {
                    acceptTerms = false
                    $('.confirmModalBtn').prop('disabled', true)
                }
            });

            $('.displayFullname').html(firstname + " " + lastname)
            $('.displayDob').html(dateOfBirth)
            $('.displayHeight').html(height + "cm")
            $('.displaySex').html(sexDesc)

            $('#confirmCreation').modal()
            //console.log(firstname, lastname, height, dateOfBirth, sex);
        }

    }

    NECharacter.LoadingResponse = function (category, state, data) {
        if (state == false) {
            var type = data.type
            var title = data.title
            var msg = data.msg
            $('.loading-menu').fadeOut(600)

            if (type !== null) {
                if (type == "error") {
                    toastr.error(msg, title)
                } else if (type == "success") {
                    toastr.success(msg, title)
                } else if (type == "info") {
                    toastr.info(msg, title)
                }
            }

            if (category == "onCreateCharacterSuccess") {
                $('.loading-menu').fadeOut(1000)
                $('.main-menu').fadeIn(1000)
                settings = data.characters
                $('#firstname').val("")
                $('#lastname').val("")
                $('#height').val("")
                characterSelected = 0
                canSelectOne = true

                NECharacter.SetupMainTitle()
            } else if (category == "onDeleteCharacterSuccess") {
                settings = data.characters
                $('.loading-menu').fadeOut(1000)
                $('.main-menu').fadeIn(1000)
                characterSelected = 0
                canSelectOne = true

                NECharacter.SetupMainTitle()
            } else {
                $('.loading-menu').fadeOut(500)
                setTimeout(() => {
                    $('.create-character').fadeIn(1000)
                }, 600);

            }
        } else {
            if (category == "onCreateCharacter") {
                $('#confirmCreation').modal('hide')
                $('.create-character').fadeOut(1000)
                setTimeout(() => {
                    $('.loading-menu').fadeIn(1000)
                }, 900);

            } else if (category == "onDeleteCharacter") {
                $('.main-menu').fadeOut(1000)
                setTimeout(() => {
                    $('.loading-menu').fadeIn(1000)
                }, 900);
            } else if (category == "enableLoading") {
                $('.main-menu').fadeOut(1000)
                setTimeout(() => {
                    $('.loading-menu').fadeIn(1000)
                }, 900);
            } else if (category == "disableLoading") {
                $('.loading-menu').fadeOut(1000)
                setTimeout(() => {
                    $('.main-menu').fadeIn(1000)
                }, 900);
            }
        }
    }

    NECharacter.CloseUI = function () {
        $('.main-menu').css({ "display": "none" });
        $('.loading-menu').css({ "display": "none" })
        $('.create-character').css({ "display": "none" })
    };

    NECharacter.CreateNew = function (id) {
        characterSelected = id
        if (canSelectOne) {
            canSelectOne = false
            $(".dob").flatpickr({
                dateFormat: 'd-m-Y',
                minDate: "01-01-1940",
                maxDate: "01-10-2010",
                locale: 'es',
                defaultDate: '01-01-2000',
                onClose: function (selectedDates, dateStr, instance) {
                    dateOfBirth = dateStr
                    //console.log(dateStr);
                }
            })
            $('.main-menu').fadeOut(2000)

            setTimeout(() => {
                $('.create-character').fadeIn(2000)
            }, 1500);
        }
    }

    NECharacter.GoToMainMenu = function () {
        $('.create-character').fadeOut(2000)

        setTimeout(() => {
            $('.main-menu').fadeIn(2000)
            canSelectOne = true
        }, 1500);
    }

    NECharacter.Delete = function (id) {
        characterSelected = id
        if (canSelectOne) {
            canSelectOne = false

            $.post('https://nex_characters/DeleteCharacter', JSON.stringify({
                charSelected: characterSelected
            }))
        }
    }

    NECharacter.PlayWithHim = function (id) {
        characterSelected = id
        if (canSelectOne) {
            canSelectOne = false

            $.post('https://nex_characters/PlayWithHim', JSON.stringify({
                charSelected: characterSelected
            }))
        }
    }

    window.addEventListener('message', function (event) {
        switch (event.data.action) {
            case 'setServerConfig':
                $('.serverTitle').html(event.data.title);
                break;
            case 'stopTutorialIntro':
                $('.tutorial-ui').fadeOut(3000)
                break
            case 'canSelectAgain':
                canSelectOne = true
                break
            case 'enableLoadingScreen':
                NECharacter.EnableLoadingScreen()
                break
            case 'openui':
                canSelectOne = true
                NECharacter.ShowUI(event.data);
                break;
            case 'closeui':
                NECharacter.CloseUI();
                break;
            case 'response':
                NECharacter.LoadingResponse(event.data.responseCat, event.data.responseState, event.data.response)
                break;
        }
    });
})