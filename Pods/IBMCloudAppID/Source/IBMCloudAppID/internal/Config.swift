/* *     Copyright 2016, 2017 IBM Corp.
 *     Licensed under the Apache License, Version 2.0 (the "License");
 *     you may not use this file except in compliance with the License.
 *     You may obtain a copy of the License at
 *     http://www.apache.org/licenses/LICENSE-2.0
 *     Unless required by applicable law or agreed to in writing, software
 *     distributed under the License is distributed on an "AS IS" BASIS,
 *     WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *     See the License for the specific language governing permissions and
 *     limitations under the License.
 */


import Foundation
import BMSCore

internal class Config {
    
    private static var oauthEndpoint = "/oauth/v3/"
    private static var attributesEndpoint = "/api/v1/"
    private static var serverUrlPrefix = "https://appid-oauth"
    private static var attributesUrlPrefix = "https://appid-profiles"
    private static var publicKeysEndpoint = "/publickeys"
    private static var urlProtocol = "http"
    
    
    private static var REGION_US_SOUTH_OLD = ".ng.bluemix.net";
    private static var REGION_US_EAST_OLD = ".us-east.bluemix.net";
    private static var REGION_UK_OLD = ".eu-gb.bluemix.net";
    private static var REGION_SYDNEY_OLD = ".au-syd.bluemix.net";
    private static var REGION_GERMANY_OLD = ".eu-de.bluemix.net";
    private static var REGION_TOKYO_OLD = ".jp-tok.bluemix.net";
    
    internal static let logger =  Logger.logger(name: AppIDConstants.ConfigLoggerName)
    
    internal static func getServerUrl(appId:AppID) -> String {
        
        guard let region = appId.region, let tenant = appId.tenantId else {
            logger.error(message: "Could not set server url properly, no tenantId or no region set")
            return serverUrlPrefix
        }
        
        var serverUrl = region.starts(with: urlProtocol) ? region + oauthEndpoint : serverUrlPrefix + region + oauthEndpoint
        if let overrideServerHost = AppID.overrideServerHost {
            serverUrl = overrideServerHost
        }
        
        serverUrl = serverUrl + tenant
        return serverUrl
    }
    
    internal static func getAttributesUrl(appId:AppID) -> String {
        
        guard let region = appId.region else {
            logger.error(message: "Could not set server url properly, no region set")
            return serverUrlPrefix
        }
        
        var attributesUrl = region.starts(with: urlProtocol) ? region + attributesEndpoint : attributesUrlPrefix + region + attributesEndpoint
        if let overrideHost = AppID.overrideAttributesHost {
            attributesUrl = overrideHost
        }
        
        return attributesUrl
    }
    
    internal static func getPublicKeyEndpoint(appId: AppID) -> String {
        return getServerUrl(appId:appId) + publicKeysEndpoint
    }

    internal static func getIssuer(appId: AppID) -> String? {
        
        if let overrideServerHost = AppID.overrideServerHost {
            return  URL(string: overrideServerHost)?.host ?? AppID.overrideServerHost
        }
        
        let region = appId.region ?? ""
        let issuer =  region.range(of:"cloud.ibm.com") == nil ? getServerUrl(appId:appId) : serverUrlPrefix + suffixFromRegion(region: region)
        
        return URL(string: issuer)?.host ?? issuer
    }
    
    internal static func suffixFromRegion(region: String) -> String {
        switch region {
        case AppID.REGION_UK_STAGE1:
            return ".stage1" + REGION_UK_OLD;
        case AppID.REGION_US_SOUTH_STAGE1:
            return ".stage1" + REGION_US_SOUTH_OLD;
        case AppID.REGION_US_SOUTH:
            return REGION_US_SOUTH_OLD;
        case AppID.REGION_UK:
            return REGION_UK_OLD;
        case AppID.REGION_SYDNEY:
            return REGION_SYDNEY_OLD;
        case AppID.REGION_GERMANY:
            return REGION_GERMANY_OLD;
        case AppID.REGION_US_EAST:
            return REGION_US_EAST_OLD;
        case AppID.REGION_TOKYO:
            return REGION_TOKYO_OLD;
        default:
            return region;
        }
        
    }
}
