// JavaScript Document
(function(){
	var logo = $('.logo'), a = 200, b = 500, c = 2000, d = 3000, a1;
	logo.css({marginTop:($('header').height()-$('.logo').height())/2}).click(function(){window.location = 'index.html';});
	
	$('#right-icon>li:nth-child(1)').click(function(){
		$('.icon-1').animate({backgroundPosition:'-60px 0'},a,'easeInOutQuad');
		$('.icon-2, .icon-3, .icon-4').animate({backgroundPosition:'0 0'},a,'easeInOutQuad');
		setTimeout(function(){window.location = 'item1.html';},b);
	});
	
	$('#right-icon>li:nth-child(2)').click(function(){
		$('.icon-2').animate({backgroundPosition:'-60px 0'},a,'easeInOutQuad');
		$('.icon-1, .icon-3, .icon-4').animate({backgroundPosition:'0 0'},a,'easeInOutQuad');
		setTimeout(function(){window.location = 'item2.html';},b);
	});
	
	$('#right-icon>li:nth-child(3)').click(function(){
		$('.icon-3').animate({backgroundPosition:'-60px 0'},a,'easeInOutQuad');
		$('.icon-1, .icon-2, .icon-4').animate({backgroundPosition:'0 0'},a,'easeInOutQuad');
		setTimeout(function(){window.location = 'item3.html';},b);
	});
	
	/*$('#right-icon>li:nth-child(4)').click(function(){
		$('.icon-4').animate({backgroundPosition:'-60px 0'},a,'easeInOutQuad');
		$('.icon-1, .icon-3, .icon-2').animate({backgroundPosition:'0 0'},a,'easeInOutQuad');
		setTimeout(function(){window.location = 'item4.html';},b);
	});*/
	
	a1 = function(){
		setTimeout(function(){$('#img1').fadeOut(c);},3000);
		setTimeout(function(){$('#img2').fadeIn(c);},3000);
		setTimeout(function(){$('#img2').fadeOut(c);},9000);
		setTimeout(function(){$('#img1').fadeIn(c);},9000);	
		setTimeout(function(){a1();},12000);
	};
	
	a1();
	
})();
