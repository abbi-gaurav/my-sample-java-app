package kyma.samples.helm.controllers;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping(path = "/api")
public class SampleController {

    @GetMapping()
    public String callAPI(){
        return "Hello from sample controller";
    }
}
