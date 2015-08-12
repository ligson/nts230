package com.boful.bmc.app;

import java.rmi.Remote;
import java.rmi.RemoteException;

/**
 * Created by ligson on 14-8-5.
 */
public interface IFileQuery{
    public int queryTranscodeState(String fileHash);
}
