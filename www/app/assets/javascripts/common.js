$(document).ready(function(){
    
    "use strict";

    //***** Progress Bar *****//
    var loaded = 0;
    var imgCounter = $("body img").length;
    if(imgCounter > 0){
        $("body img").load(function() {
          loaded++;
          var newWidthPercentage = (loaded / imgCounter) * 100;
          console.log('ok');
          animateLoader(newWidthPercentage + '%');      
        });
    }else{
      setTimeout(function(){
          $("#progressBar").css({
            "opacity":0,
            "width":"100%"
          });
      },500);
    }
    function animateLoader(newWidth) {
        $("#progressBar").width(newWidth);
        if(imgCounter === loaded){
          setTimeout(function(){
              $("#progressBar").animate({opacity:0});
          },500);
        }
    }

    //***** Side Menu *****//
      $(".side-menus li.menu-item-has-children > a").on("click",function(){
          $(this).parent().siblings().children("ul").slideUp();
          $(this).parent().siblings().removeClass("active");
          $(this).parent().children("ul").slideToggle();
          $(this).parent().toggleClass("active");
          return false;
      });

      //***** Side Menu Option *****//
      $('.menu-options').on("click", function(){
        $(".side-header.opened-menu").toggleClass('slide-menu');
        $(".main-content").toggleClass('wide-content');
        $("footer").toggleClass('wide-footer');
        $(".menu-options").toggleClass('active');
      });

    /*** FIXED Menu APPEARS ON SCROLL DOWN ***/   
    $(window).scroll(function() {    
        var scroll = $(window).scrollTop();
        if (scroll >= 10) {
        $(".side-header").addClass("sticky");
        }
        else{
        $(".side-header").removeClass("sticky");
        $(".side-header").addClass("");
        }
    }); 

    $(".side-menus nav > ul > li ul li > a").on("click", function(){
        $(".side-header").removeClass("slide-menu");
        $(".menu-options").removeClass("active");
    });

      //***** Quick Stats *****//
      $('.show-stats').on("click", function(){
        $(".toggle-content").addClass('active');
      });
     
       //***** Quick Stats *****//
      $('.toggle-content > span').on("click", function(){
        $(".toggle-content").removeClass('active');
      });

      //***** Quick Stats *****//
      $('.quick-links > ul > li > a').on("click", function(){
        $(this).parent().siblings().find('.dialouge').fadeOut();
        $(this).next('.dialouge').fadeIn();
        return false;
      });

      $("html").on("click", function(){
        $(".dialouge").fadeOut();
      });
      $(".quick-links > ul > li > a, .dialouge").on("click",function(e){
            e.stopPropagation();
        });
      
      //***** Toggle Full Screen *****//
      function goFullScreen() {
        var
            el = document.documentElement
          , rfs =
                 el.requestFullScreen
              || el.webkitRequestFullScreen
              || el.mozRequestFullScreen
              || el.msRequestFullscreen

      ;
      rfs.call(el);
      }
      $("#toolFullScreen").on("click",function() {
          goFullScreen();
      });

      //***** Side Menu *****//
      $(function(){
          $('.side-menus').slimScroll({
              height: '400px',
              wheelStep: 10,
              size: '2px'
          });
      });


      $(".data-attributes span").peity("donut");

    // Activates Tooltips for Social Links
    $('[data-toggle="tooltip"]').tooltip(); 

    // Activates Popovers for Social Links 
    $('[data-toggle="popover"]').popover(); 


    //*** Refresh Content ***//
    $('.refresh-content').on("click", function(){
      $(this).parent().parent().addClass("loading-wait").delay(3000).queue(function(next){
        $(this).removeClass("loading-wait");
        next();
    });
    $(this).addClass("fa-spin").delay(3000).queue(function(next){
        $(this).removeClass("fa-spin");
        next();
    });
    });

    //*** Expand Content ***//
    $('.expand-content').on("click", function(){
      $(this).parent().parent().toggleClass("expand-this");
    });

    //*** Delete Content ***//
    $('.close-content').on("click", function(){
      $(this).parent().parent().slideUp();
    });

    // Activates Tooltips for Social Links
    $('.tooltip-social').tooltip({
      selector: "a[data-toggle=tooltip]"
    });



});