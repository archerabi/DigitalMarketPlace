

var pollId;
var timerId;
var orderId;
var time ;

function createOrder(product_id)
{
	$("#buy-widget-container").append("<div><label id=\"buy-widget-root\"/>");
	$("#buy-widget-root").append("<div><label id=\"timer\"/></div><div id = \"send-address\"></div>");
	$("#buy-widget-root").append("<div><label id=\"price\"/>");
	$.post("/orders",{ product_id : product_id},
	    function(data) {
	       $("#send-address").append("<p> Send bitcoin to " + data.order.receive_address+" .</p>");
	       $("#price").append("<p>"+data.order.btc_price+" BTC </p>");
	       $("#buy-button").hide();
	       orderId = data.order.id;
	       time = 10 * 60 * 1000;
	       pollId = setInterval(pollOrder, 10000); // one hour check.
	       timerId = setInterval(timer,1000);
	    }
	);
}

function timer()
{

	time = time - 1000;
	if( time <= 0)
	{
		removePayWidget();
		$("#buy-button").show();
		return;
	}
	var minutes = Math.floor(time / (1000 * 60) );
	var seconds = Math.floor( (time/1000) % 60) ;
	$('#timer').text(minutes+':'+seconds);
}

function pollOrder()
{
	$.get( "/orders/"+orderId, function( data ) {
		if( data.paid )
		{
			removePayWidget();
			getDownloadCode();
		}
	});
}

function getDownloadCode()
{
	$.get( "/orders/"+orderId+"/download", function( data ) {
		if( data.success )
		{
			var code = data.code;
			var path = window.location.origin+'/products/download/'+code;
			$("#buy-widget-container").append("<a href='"+path+"'> Download </a>");
		}
	});
}

function removePayWidget()
{
	$('#buy-widget-root').remove();
	clearInterval(pollId);  
	clearInterval(timerId);
}

