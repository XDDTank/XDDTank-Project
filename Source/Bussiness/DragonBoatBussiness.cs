using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using SqlDataProvider.Data;
using System.Data.SqlClient;
using System.Data;
namespace Bussiness
{
    public class DragonBoatBussiness : BaseBussiness
    {
        public List<UserDragonBoat> GetAllDragonBoat()
        {
            List<UserDragonBoat> infos = new List<UserDragonBoat>();
            SqlDataReader reader = null;
            try
            {
                db.GetReader(ref reader, "SP_GetAllDragonBoat");
                while (reader.Read())
                {
                    UserDragonBoat info = new UserDragonBoat();
                    info.UserID = (int)reader["UserID"];
                    info.NickName = (string)reader["NickName"];
                    info.Exp = (int)reader["Exp"];
                    info.Point = (int)reader["Point"];
                    info.TotalPoint = (int)reader["TotalPoint"];
                    infos.Add(info);
                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("SP_GetAllDragonBoat", e);
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                    reader.Close();
            }
            return infos;
        }

        public UserDragonBoat GetSingleDragonBoat(int UserID)
        {
            SqlDataReader reader = null;
            try
            {
                SqlParameter[] para = new SqlParameter[1];
                para[0] = new SqlParameter("@UserID", UserID);
                db.GetReader(ref reader, "SP_GetSingleDragonBoat", para);
                while (reader.Read())
                {
                    UserDragonBoat info = new UserDragonBoat();
                    info.UserID = (int)reader["UserID"];
                    info.NickName = (string)reader["NickName"];
                    info.Exp = (int)reader["Exp"];
                    info.Point = (int)reader["Point"];
                    info.TotalPoint = (int)reader["TotalPoint"];
                    return info;
                }
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("SP_GetAllDragonBoat", e);
            }
            finally
            {
                if (reader != null && !reader.IsClosed)
                    reader.Close();
            }
            return null;
        }

        public bool UpdateDragonBoat(UserDragonBoat item)
        {
            bool flag = false;
            try
            {
                SqlParameter[] para = new SqlParameter[6];
                para[0] = new SqlParameter("@UserID", item.UserID);
                para[1] = new SqlParameter("@NickName", item.NickName);
                para[2] = new SqlParameter("@Exp", item.Exp);
                para[3] = new SqlParameter("@Point", item.Point);
                para[4] = new SqlParameter("@TotalPoint", item.TotalPoint);
                para[5] = new SqlParameter("@Result", System.Data.SqlDbType.Int);
                para[5].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_UpdateDragonBoat", para);
                flag = (int)para[5].Value == 0;
                item.IsDirty = false;
            }
            catch (Exception exception)
            {
                if (BaseBussiness.log.IsErrorEnabled)
                {
                    BaseBussiness.log.Error("SP_UpdateDragonBoat", exception);
                }
            }
            return flag;
        }

        public bool AddDragonBoat(UserDragonBoat item)
        {
            bool result = false;
            try
            {
                SqlParameter[] para = new SqlParameter[6];
                para[0] = new SqlParameter("@UserID", item.UserID);
                para[1] = new SqlParameter("@NickName", item.NickName);
                para[2] = new SqlParameter("@Exp", item.Exp);
                para[3] = new SqlParameter("@Point", item.Point);
                para[4] = new SqlParameter("@TotalPoint", item.TotalPoint);
                para[5] = new SqlParameter("@Result", System.Data.SqlDbType.Int);
                para[5].Direction = ParameterDirection.ReturnValue;
                db.RunProcedure("SP_AddDragonBoat", para);
                result = (int)para[5].Value == 0;
                item.IsDirty = false;
            }
            catch (Exception e)
            {
                if (log.IsErrorEnabled)
                    log.Error("Init", e);
            }
            finally
            {
            }
            return result;
        }

    }
}
