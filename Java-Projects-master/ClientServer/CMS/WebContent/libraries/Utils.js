var utils = (function () {
    function httpGet(params) {
        $.ajax({
            "url": params.url,
            "type": params.type || "GET",
            "data": params.data,
            contentType: 'application/json',
            "success": params.successCallback,
            "error": params.errorCallback
        });
    }

    function getURLParameter(name) {
        return decodeURIComponent((new RegExp('[?|&]' + name + '=' + '([^&;]+?)(&|#|;|$)').exec(location.search) || [, ""])[1].replace(/\+/g, '%20')) || null
    }

    function httpPost(params) {
        $.ajax({
            "url": params.url,
            "type": "POST",
            "data": params.data,
            contentType: 'application/json',
            dataType: 'json',
            "success": params.successCallback,
            "error": params.errorCallback
        });
    }

    function getUTCTime(date) {
        var curDate = new Date(date),
            newDate = new Date(curDate.getFullYear(), curDate.getMonth(), curDate.getDate(), 0, 0, 0, 0),
            utcDate = newDate.getTime() + (newDate.getTimezoneOffset()*60*1000);

//        console.log(utcDate);
//        return utcDate;
        return newDate.getTime();
    }

    return {
        "httpGet": httpGet,
        "getURLParameter": getURLParameter,
        "httpPost": httpPost,
        "getUTCTime": getUTCTime
    }
})();



