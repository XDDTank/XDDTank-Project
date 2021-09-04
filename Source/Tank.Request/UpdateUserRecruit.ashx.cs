using Bussiness;
using log4net;
using SqlDataProvider.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Web;
using System.Xml.Linq;

namespace Tank.Request
{
    /// <summary>
    /// Summary description for UpdateUserRecruit
    /// </summary>
    public class UpdateUserRecruit : IHttpHandler
    {
        private static readonly ILog log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        public void ProcessRequest(HttpContext context)
        {
            bool value = false;
            string message = "Fail!";

            XElement result = new XElement("Result");
            try
            {
                int userid = Convert.ToInt32(HttpUtility.UrlDecode(context.Request["UserId"]));
                int savepoint = Convert.ToInt32(HttpUtility.UrlDecode(context.Request["ScheduleId"]));
                using (PlayerBussiness db = new PlayerBussiness())
                {
                    PlayerInfo info = db.GetUserSingleByUserID(userid);

                    if (info != null && db.UpdatePlayerSavePoint(userid, savepoint))
                    { 
                        value = true;
                        message = "Success!";
                    }
                }


            }
            catch (Exception ex)
            {
                log.Error("UpdateUserRecruit", ex);
            }
            finally
            {
                result.Add(new XAttribute("value", value));
                result.Add(new XAttribute("message", message));
                context.Response.ContentType = "text/plain";
                context.Response.Write(result.ToString(false));
            }
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}