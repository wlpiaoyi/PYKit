if(ios == undefined){
    var ios = {};
}
ios.hybirdPrompt = "qqpiaoyi_prompt";
window.hybird = {
    call : undefined,
    persistInstance : undefined,
    mergeInstance : undefined,
    removeInstacne : undefined,
    instanceObjs : [],
    callbackResults : {}
};
/**
 调用本地代码
 */
window.hybird.call = function (instanceName, methodName, params){
    //返回数据
    var result = {
        value : undefined,
        error : undefined
    };
    try{
        //传入参数，通过prompt的方式调用native代码
        var nativeParams = {
            instanceName:instanceName,
            methodName:methodName,
            params:params
        };
        var resultValue = window.prompt(ios.hybirdPrompt,JSON.stringify(nativeParams));
        if(resultValue){
            if(typeof resultValue == "string"){
                var obj = eval("("+resultValue+")");
                if(!obj.error){
                    result.error = undefined;
                    result.value = obj.value;
                }else{
                    result.error = obj.error;
                }
            }else{
                result.error = new Error(10,"the resultValue of instance '"+ instanceName+"' type error!") ;
                result.value = undefined;
            }
        }
    }catch(error){
        result.error = error;
        result.value = undefined;
    }
    if(result.error){
        alert("Error name: " + error.name + "\n" + "Error message: " + error.message);
    }
    return result.value;
}

window.hybird.persistInstance = function (instanceObj, instanceId){
    instanceObj.id = instanceId;
    window.hybird.instanceObjs.push(instanceObj);
}

window.hybird.mergeInstance = function (instanceObj, instanceId){
    window.hybird.removeInstacne(instanceId);
    window.hybird.persistInstance(instanceObj, instanceId);
}

window.hybird.removeInstacne = function (instanceId){
    for (var i = 0; i < window.hybird.instanceObjs.length; i++) {
        var instanceObj = window.hybird.instanceObjs[i];
        if(instanceObj.id != instanceId){
            continue;
        }
        window.hybird.instanceObjs.remove(instanceObj);
        break;
    }
}
