/***
@title:
Image Zoom

@version:
2.0

@author:
Andreas Lagerkvist

@date:
2008-08-31

@url:
http://andreaslagerkvist.com/jquery/image-zoom/

@license:
http://creativecommons.org/licenses/by/3.0/

@copyright:
2008 Andreas Lagerkvist (andreaslagerkvist.com)

@requires:
jquery, jquery.imageZoom.css, jquery.imageZoom.png

@does:
This plug-in makes links pointing to images open in the "Image Zoom". Clicking a link will zoom out the clicked image to its target-image. Click anywhere on the image or the close-button to zoom the image back in. Only ~3k minified.

@howto:
jQuery(document.body).imageZoom(); Would make every link pointing to an image in the document open in the zoom.

@exampleHTML:
<ul>
	<li><a href="http://exscale.se/__files/3d/bloodcells.jpg">Bloodcells</a></li>
	<li><a href="http://exscale.se/__files/3d/x-wing.jpg">X-Wing</a></li>
	<li><a href="http://exscale.se/__files/3d/weve-moved.jpg">We've moved</a></li>
</ul>

<ul>
	<li><a href="http://exscale.se/__files/3d/lamp-and-mates/lamp-and-mates-01.jpg"><img src="http://exscale.se/__files/3d/lamp-and-mates/lamp-and-mates-01_small.jpg" alt="Lamp and Mates" /></a></li>
	<li><a href="http://exscale.se/__files/3d/stugan-winter.jpg"><img src="http://exscale.se/__files/3d/stugan-winter_small.jpg" alt="The Cottage - Winter time" /></a></li>
	<li><a href="http://exscale.se/__files/3d/ps2.jpg"><img src="http://exscale.se/__files/3d/ps2_small.jpg" alt="PS2" /></a></li>
</ul>

@exampleJS:
// I don't run it because my site already uses imgZoom
// jQuery(document.body).imageZoom();
***/
jQuery.fn.imageZoom = function (conf) {
	// Some config. If you set dontFadeIn: 0 and hideClicked: 0 imgzoom will act exactly like fancyzoom
	var config = jQuery.extend({
		speed:			200,	// Animation-speed of zoom
		dontFadeIn:		1,		// 1 = Do not fade in, 0 = Do fade in
		hideClicked:	1,		// Whether to hide the image that was clicked to bring up the imgzoom
		imageMargin:	30,		// Margin from image-edge to window-edge if image is larger than screen
		className:		'jquery-image-zoom', 
		loading:		'Loading...'
	}, conf);
	config.doubleSpeed = config.speed / 4; // Used for fading in the close-button

	return this.click(function(e) {
		// Make sure the target-element is a link (or an element inside a link)
		var clickedElement	= jQuery(e.target); // The element that was actually clicked
		var clickedLink		= clickedElement.is('a') ? clickedElement : clickedElement.parents('a'); // If it's not an a, check if any of its parents is
			clickedLink		= (clickedLink && clickedLink.is('a') && clickedLink.attr('href').search(/(.*)\.(jpg|jpeg|gif|png|bmp|tif|tiff)$/gi) != -1) ? clickedLink : false; // If it was an a or child of an a, make sure it points to an image
		var clickedImg		= (clickedLink && clickedLink.find('img').length) ? clickedLink.find('img') : false; // See if the clicked link contains and image

		// Only continue if a link pointing to an image was clicked
		if (clickedLink) {
			// These functions are used when the imaeg starts and stops loading (displays either 'loading..' or fades out the clicked img slightly)
			clickedLink.oldText	= clickedLink.text();

			clickedLink.setLoadingImg = function () {
				if (clickedImg) {
					clickedImg.css({opacity: '0.5'});
				}
				else {
					clickedLink.text(config.loading);
				}
			};

			clickedLink.setNotLoadingImg = function () {
				if (clickedImg) {
					clickedImg.css({opacity: '1'});
				}
				else {
					clickedLink.text(clickedLink.oldText);
				}
			};

			// The URI to the image we are going to display
			var displayImgSrc = clickedLink.attr('href');

			// If an imgzoom wiv this image is already open dont do nathin
			if (jQuery('div.' + config.className + ' img[src="' + displayImgSrc + '"]').length) {
				return false;
			}

			// This function is run once the displayImgSrc-img has loaded (below)
			var preloadOnload = function () {
				// The clicked-link is faded out during loading, fade it back in
				clickedLink.setNotLoadingImg();

				// Now set some vars we need
				var dimElement		= clickedImg ? clickedImg : clickedLink; // The element used to retrieve dimensions of imgzoom before zoom (either clicked link or img inside)
				var hideClicked		= clickedImg ? config.hideClicked : 0; // Whether to hide clicked link (set in config but always true for non-image-links)
				var offset			= dimElement.offset(); // Offset of clicked link (or image inside)
				var imgzoomBefore	= { // The dimensions of the imgzoom _before_ it is zoomed out
					width:		dimElement.outerWidth(), 
					height:		dimElement.outerHeight(), 
					left:		offset.left, 
					top:		offset.top/*, 
					opacity:	config.dontFadeIn*/
				};
				var imgzoom			= jQuery('<div><img src="' + displayImgSrc + '" alt="" /></div>').css('position', 'absolute').appendTo(document.body); // We don't want any class-name or any other contents part from the image when we calculate the new dimensions of the imgzoom
				var imgzoomAfter	= { // The dimensions of the imgzoom _after_ it is zoomed out
					width:		imgzoom.outerWidth(), 
					height:		imgzoom.outerHeight()/*, 
					opacity:	1*/
				};
				var windowDim = {
					width:	jQuery(window).width(), 
					height:	jQuery(window).height()
				};
				// Make sure imgzoom isn't wider than screen
				if (imgzoomAfter.width > (windowDim.width - config.imageMargin * 2)) {
					var nWidth			= windowDim.width - config.imageMargin * 2;
					imgzoomAfter.height	= (nWidth / imgzoomAfter.width) * imgzoomAfter.height;
					imgzoomAfter.width	= nWidth;
				}
				// Now make sure it isn't taller
				if (imgzoomAfter.height > (windowDim.height - config.imageMargin * 2)) {
					var nHeight			= windowDim.height - config.imageMargin * 2;
					imgzoomAfter.width	= (nHeight / imgzoomAfter.height) * imgzoomAfter.width;
					imgzoomAfter.height	= nHeight;
				}
				// Center imgzoom
				imgzoomAfter.left	= (windowDim.width - imgzoomAfter.width) / 2 + jQuery(window).scrollLeft();
				imgzoomAfter.top	= (windowDim.height - imgzoomAfter.height) / 2 + jQuery(window).scrollTop();
				var closeButton		= jQuery('<a href="#">Close</a>').appendTo(imgzoom).hide(); // The button that closes the imgzoom (we're adding this after the calculation of the dimensions)

				// Hide the clicked link if set so in config
				if (hideClicked) {
					clickedLink.css('visibility', 'hidden');
				}

				// Now animate the imgzoom from its small size to its large size, and then fade in the close-button
				imgzoom.addClass(config.className).css(imgzoomBefore).animate(imgzoomAfter, config.speed, function () {
					closeButton.fadeIn(config.doubleSpeed);
				});

				// This function closes the imgzoom
				var hideImgzoom = function () {
					closeButton.fadeOut(config.doubleSpeed, function () {
						imgzoom.animate(imgzoomBefore, config.speed, function () {
							clickedLink.css('visibility', 'visible');
							imgzoom.remove();
						});
					});

					return false;
				};

				// Close imgzoom when you click the closeButton or the imgzoom
				imgzoom.click(hideImgzoom);
				closeButton.click(hideImgzoom);
			};

			// Preload image
			var preload = new Image();
				preload.src = displayImgSrc;

			if (preload.complete) {
				preloadOnload();
			}
			else {
				clickedLink.setLoadingImg();
				preload.onload = preloadOnload;
			}

			// Finally return false from the click so the browser doesn't actually follow the link...
			return false;
		}
	});
};