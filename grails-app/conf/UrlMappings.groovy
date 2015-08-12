class UrlMappings {

    static mappings = {
        "/$controller/$action?/$id?(.$format)?" {
            constraints {
                // apply constraints here
            }
        }

        //"/"(controller:"index",action:"index")
        "/admin"(controller: "admin", action: 'login')
        "500"(view: '/error500')
        "404"(view: '/error404')
    }
}
