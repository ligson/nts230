package nts.web.utils;

import grails.util.Holders;
import nts.listener.services.ConsumerListenerService;

import javax.servlet.http.HttpSessionAttributeListener;
import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

/**
 * Created by tianqiulian on 14-10-20.
 */
public class AppSessionListener implements HttpSessionListener,HttpSessionAttributeListener {
    ConsumerListenerService consumerListenerService;
    @Override
    public void sessionCreated(HttpSessionEvent httpSessionEvent) {
       init();
        consumerListenerService.sessionCreated(httpSessionEvent);
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent httpSessionEvent) {
        init();
        consumerListenerService.sessionDestroyed(httpSessionEvent);
    }

    synchronized public void init() {
        if (consumerListenerService == null) {
            consumerListenerService = (ConsumerListenerService) Holders.getApplicationContext().getBean("consumerListenerService");
        }
    }

    @Override
    public void attributeAdded(HttpSessionBindingEvent httpSessionBindingEvent) {
        init();
        consumerListenerService.attributeAdded(httpSessionBindingEvent);
    }

    @Override
    public void attributeRemoved(HttpSessionBindingEvent httpSessionBindingEvent) {
        init();
        consumerListenerService.attributeRemoved(httpSessionBindingEvent);
    }

    @Override
    public void attributeReplaced(HttpSessionBindingEvent httpSessionBindingEvent) {
        init();
        consumerListenerService.attributeReplaced(httpSessionBindingEvent);
    }
}
