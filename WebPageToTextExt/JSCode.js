
var WebPageURIProcessor = function() {};

WebPageURIProcessor.prototype = {
    
run: function(arguments) {
    arguments.completionFunction({"baseURI": document.baseURI});
 },
    
finalize: function(arguments) {

}
};

var ExtensionPreprocessingJS = new WebPageURIProcessor;