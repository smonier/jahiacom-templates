package org.jahia.modules.jahiacom.taglibs;

import org.apache.commons.io.IOUtils;
import org.jahia.settings.SettingsBean;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

public class ValidateSocialLogin {

    static final Logger logger = LoggerFactory.getLogger(ValidateSocialLogin.class);

    public static Boolean ValidateSocialLogin(String networkName, String siteKey) throws IOException {
        Properties properties = new Properties();
        String configName;
        configName = "org.jahia.modules.auth-" + siteKey + ".cfg";
        logger.info("Social Network: " + networkName + " - Site: " + siteKey + " - ConfigName: " + configName);
        File file = getExistingConfigFile(configName);
        if (file.exists()) {
            InputStream in = new FileInputStream(file);
            try {
                properties.load(in);
                //properties.forEach((key, value) -> logger.info(key + " : " + value));

                if (properties.containsKey(networkName + ".apiKey")) {
                    if (properties.getProperty(networkName + ".enabled").equals("true")) {
                        logger.info("True");
                        return true;
                    } else {
                        logger.info("False");
                        return false;
                    }
                } else {
                    logger.info("False");
                    return false;
                }
            } finally {
                IOUtils.closeQuietly(in);
            }
        } else {
            throw new IOException("Cannot find Oauth configuration file " + configName);
        }

    }

    private static File getExistingConfigFile(String configName) {
        File file = new File(SettingsBean.getInstance().getJahiaVarDiskPath(), "karaf/etc/" + configName);
        if (!file.exists()) {
            file = new File(SettingsBean.getInstance().getJahiaVarDiskPath(), "modules/" + configName);
        }
        return file;
    }
}
