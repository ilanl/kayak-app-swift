
public class CoreComponents: TyphoonAssembly {
    
//    public dynamic func forecastService() -> AnyObject {
//        return TyphoonDefinition.withClass(ForecastService.self) {
//            (definition) in
//            //definition.injectProperty("serviceUrl", with:TyphoonConfig("service.url"))
//            definition.injectProperty("forecastDao", with:self.forecastDao())
//            definition.injectProperty("daysToRetrieve", with:TyphoonConfig("days.to.retrieve"))
//        }
//    }
    
    public dynamic func forecastRepository() -> AnyObject {
        return TyphoonDefinition.withClass(ForecastRepository.self)
    }
    
//    public dynamic func forecastService() -> AnyObject {
//        
//        return TyphoonDefinition.withClass(ForecastService.self) {
//            (definition) in
//            
//            definition.useInitializer("initWithDefaults:") {
//                (initializer) in
//                
//                initializer.injectParameterWith(NSUserDefaults.standardUserDefaults())
//            }
//        }
//    }
}
