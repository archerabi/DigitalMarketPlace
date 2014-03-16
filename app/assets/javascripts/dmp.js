

var pollId;
var timerId;
var orderId;
var time ;
var check_balance_internal_seconds = 10;
var wallet_expire_time_minutes = 10;

function createOrder(product_id)
{

    $('#buyButton').hide();
    $("#send-address").text("Creating destination address with CoinBase. Please wait...");

	$.post("/orders",{ product_id : product_id},
	    function(data) {
	       $("#send-address").text("<p> Please don't refresh the page until you finish checkout</p><p> Send "+ data.order.btc_price +" BTC to " + data.order.receive_address + " .</p>");
	       orderId = data.order.id;
	       time = wallet_expire_time_minutes * 60 * 1000;
	       pollId = setInterval(pollOrder, check_balance_internal_seconds * 1000); // 10 second check.
	       timerId = setInterval(timer,1000);
	    }
	).fail(function () {
                $("#send-address").text("Error contacting CoinBase...");
                $('#buyButton').show();
    });;
}

function timer()
{

	time = time - 1000;
	if( time <= 0)
	{
		removePayWidget();
		$("#buyButton").show();
		return;
	}
	var minutes = Math.floor(time / (1000 * 60) );
	var seconds = Math.floor( (time/1000) % 60) ;
	if ( seconds < 10)
	{
		seconds = '0'+ seconds;
	}
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
			$("#downloadLink").append("<a href='"+path+"'> Download </a>");
		}
	});
}

function removePayWidget()
{
	$('#send-address').text('');
	$('#timer').hide();
	clearInterval(pollId);  
	clearInterval(timerId);
}

