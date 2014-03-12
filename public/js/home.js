  var purchaseHoldFingerPosition = 0;
  var loadMoreHoldFingerPosition = 0;
  var mySwiper = new Swiper('.swiper-container',{
    slidesPerView:'1',
    watchActiveIndex: true,
    onSlideChangeStart: function(){
    	//alert('slide changed: ' + mySwiper.activeIndex );

			// If this is the last slide, don't remove it. Let pull to load more trigger.
			if ( 0 == mySwiper.activeIndex ) {
				return;
			}

			// Otherwise remove any previous slides.
			for(var i = 0; i < mySwiper.activeIndex; i++) {
	    	mySwiper.removeSlide(i);			
			}
    	
    	// Adjust index so we stay on the new slide we just swiped to.
    	mySwiper.swipeTo(0, 0, false);
    },
    onTouchStart: function() {
      purchaseHoldFingerPosition = 0;
      loadMoreHoldFingerPosition = 0;
    },
    onResistanceBefore: function(s, pos){
      purchaseHoldFingerPosition = pos;
      
      var activeSlide = mySwiper.activeSlide();
      if ( !$(activeSlide).hasClass('stampedApproved') ) {
      		$(activeSlide).addClass('stampedApproved');
      }
      
    },
    onResistanceAfter: function(s, pos){
      loadMoreHoldFingerPosition = pos;      
    },
    onTouchMove: function() {    	
    	//if ( mySwiper.touches.diff < 0 ) {
	      //var activeSlide = mySwiper.activeSlide();
	      //if ( !$(activeSlide).hasClass('stampedNo') ) {
 	     	//	$(activeSlide).addClass('stampedNo');
  	    //}	
    	//}
    },
    onSlideReset: function() {
    	var activeSlide = mySwiper.activeSlide();
      $(activeSlide).removeClass('stampedApproved');
      $(activeSlide).removeClass('stampedNo');    	
    },
    onTouchEnd: function(){
    
    	var activeSlide = mySwiper.activeSlide();
    	
    	// If user swiped right past cards and held.
      if (purchaseHoldFingerPosition>100) {
      
      	$(activeSlide).removeClass('stampedApproved');
      
        // Hold Swiper in required position
        mySwiper.setWrapperTranslate(0,100,0)

        //Dissalow futher interactions
        mySwiper.params.onlyExternal=true

        //Show loader
        $('.preloader').addClass('visible');

          // Click buy link.
          var activeSlide = mySwiper.activeSlide();
          var activeSlideBuyHref = $(activeSlide).find('.rightimage').click();

        return;
      }

			// If user swiped left past cards and held.      
      if (loadMoreHoldFingerPosition>100) {
      	//TODO: load more if we have separate pages
      	alert(' Nothing more for sale. Try back later! ');
      }
      
    }
  });

  $('.buy-button').on('click', function(e){
    e.preventDefault()

		// Click buy link.
		var activeSlide = mySwiper.activeSlide();
		var activeSlideBuyHref = $(activeSlide).find('.rightimage').click();

  });
  
  $('.next-button').on('click', function(e){
    e.preventDefault();
        
    mySwiper.swipeTo(1, 1000, false);
    setTimeout(function() {
	    mySwiper.removeSlide(0);	
			mySwiper.swipeTo(0, 0, false);    
    }, 1001);

  });
  
  