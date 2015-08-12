package com.boful.nts.service.model;

import java.io.Serializable;

/**
 * Created by lvy6 on 14-6-9.
 */
public class RMSNode implements Serializable{

    private static final long serialVersionUID = -3941214854810157573L;

    private String rmsIPAddress;
    private int rmsIPPort;
    private String bmcIPAddress;
    private int bmcWebPort;
    private int bmcFilePort;
    private int bmcRmiPort = 1683;

    public RMSNode(){
    }



    public String getRmsIPAddress(){
        return rmsIPAddress;
    }

    public void setRmsIPAddress(String rmsIPAddress){
        this.rmsIPAddress = rmsIPAddress;
    }

    public int getRmsIPPort(){
        return rmsIPPort;
    }

    public void setRmsIPPort (int rmsIPPort){
        this.rmsIPPort = rmsIPPort;
    }

    public String getBmcIPAddress(){
        return bmcIPAddress;
    }

    public void setBmcIPAddress(String bmcIPAddress){
        this.bmcIPAddress = bmcIPAddress;
    }

    public int getBmcWebPort(){
        return bmcWebPort;
    }

    public void setBmcWebPort(int bmcWebPort){
        this.bmcWebPort = bmcWebPort;
    }

    public int getBmcFilePort(){
        return bmcFilePort;
    }

    public void setBmcFilePort(int bmcFilePort){
        this.bmcFilePort = bmcFilePort;
    }

    @Override
    public String toString()  {
        return "RMSNode{" +
                "rmsIPAddress='" + rmsIPAddress + '\'' +
                ", rmsIPPort=" + rmsIPPort +
                ", bmcIPAddress='" + bmcIPAddress + '\'' +
                ", bmcWebPort=" + bmcWebPort +
                ", bmcFilePort=" + bmcFilePort +
                '}';
    }

    public int getBmcRmiPort() {
        return bmcRmiPort;
    }

    public void setBmcRmiPort(int bmcRmiPort) {
        this.bmcRmiPort = bmcRmiPort;
    }
}
