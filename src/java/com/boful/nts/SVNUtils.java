package com.boful.nts;

import org.tmatesoft.svn.core.SVNURL;
import org.tmatesoft.svn.core.auth.ISVNAuthenticationManager;
import org.tmatesoft.svn.core.io.SVNRepository;
import org.tmatesoft.svn.core.io.SVNRepositoryFactory;
import org.tmatesoft.svn.core.wc.SVNWCUtil;

/**
 * Created by ligson on 14-12-17.
 */
public class SVNUtils {
    public static long getLastVersion() {
        try {
            String svnRoot = "http://repos.ouknow.com/nts230/trunk";
            SVNRepository repository = SVNRepositoryFactory.create(SVNURL.parseURIEncoded(svnRoot));
            ISVNAuthenticationManager authManager = SVNWCUtil.createDefaultAuthenticationManager("tianqiulian", "password");
            repository.setAuthenticationManager(authManager);
            long lastVersion = repository.getLatestRevision();
            return lastVersion;
        } catch (Exception e) {
            return -1;
        }
    }
}
