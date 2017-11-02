/*
 * Image preview script 
 * powered by jQuery (http://www.jquery.com)
 * 
 * written by Alen Grakalic (http://cssglobe.com)
 * 
 * for more info visit http://cssglobe.com/post/1695/easiest-tooltip-and-image-preview-using-jquery
 *
 */
 
this.imagePreview = function(){	
	/* CONFIG */	
		// these 2 variable determine popup's distance from the cursor
		// you might want to adjust to get the right result
	var xOffset = 0;
	var yOffset = 0;
	/* END CONFIG */
	$("img.preview").hover(function(e){
		var img = new Image();
		img.src = this.src;
		 xOffset = img.width;
		 yOffset = img.height;
		this.t = this.title;
		this.title = "";	
		var c = (this.t != "") ? "<br/>" + this.t : "";
		$("body").append("<p id='preview'><img  src='"+ this.src +"' alt='Image preview' />"+ c +"</p>");
		
		$("#preview")
			.css("top",(e.pageY - yOffset) + "px")
			.css("left",(e.pageX - xOffset) + "px")
			.fadeIn("fast");						
    },
	function(){
		this.title = this.t;	
		$("#preview").remove();
    });	
	$("img.preview").mousemove(function(e){
		$("#preview")
			.css("top",(e.pageY - yOffset) + "px")
			.css("left",(e.pageX - xOffset) + "px");
	});			
};


// starting the script on page load
$(document).ready(function(){
	imagePreview();
});