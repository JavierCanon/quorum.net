﻿using System;
using System.Data;
using System.Data.SqlClient;
using System.Web;
using Softcanon.DAL;

namespace QuorumMobile.SL
{


    /// <summary>
    /// Descripción breve de Permisos
    /// http://msdn.microsoft.com/en-us/library/c3s1ez6e(v=VS.90).aspx
    /// http://stackoverflow.com/questions/424366/c-string-enums
    ///
    /// CACHE DE LOS PERMISOS DE USUARIO:
    /// Se utiliza System.Web.HttpRuntime.Cache
    ///
    /// Con tipo sliding 
    ///
    /// http://msdn.microsoft.com/en-us/library/18c1wd61(v=vs.100).aspx
    ///
    ///
    /// </summary>
    public static class Permissions
    {

        /// <summary>
        /// Get permission for a user with user rol assigned
        /// </summary>
        /// <param name="userPerType"></param>
        /// <param name="session"></param>
        /// <param name="strDBConnection"></param>
        /// <returns></returns>
        public static bool GetPermission(UserPermissionTypeEnum userPerType, System.Web.SessionState.HttpSessionState session, string strDBConnection)
        {
            if (session["User.UserRolID"].ToString().Equals("0") // UserRolEnum.System
                || session["User.UserRolID"].ToString().Equals("1") // UserRolEnum.SuperAdministrator
                )
            {
                return true;
            }

            var key = session.SessionID + "_Permission_" + userPerType.ToString();

            var bresult = GetFromCache(key);
            if (bresult == null)
            {
                bresult = GetPermissionDB(Convert.ToString((int)userPerType), session["User.UserID"].ToString(), session["User.UserRolID"].ToString(), strDBConnection);
                HttpRuntime.Cache.Insert(key, bresult, null, System.Web.Caching.Cache.NoAbsoluteExpiration, TimeSpan.FromMinutes(5));
            }

            return (bool)bresult;
        }

        /// <summary>
        /// Get permission using HttpContext.Current.Session
        /// </summary>
        /// <param name="userPerType"></param>
        /// <param name="strDBConnection"></param>
        /// <returns></returns>
        public static bool GetPermission(UserPermissionTypeEnum userPerType, string strDBConnection)
        {
            if (HttpContext.Current.Session["User.UserRolID"].ToString().Equals("0") 
                || HttpContext.Current.Session["User.UserRolID"].ToString().Equals("1"))
            {
                return true;
            }

            var key = HttpContext.Current.Session.SessionID + "_Permission_" + userPerType.ToString();

            var bresult = GetFromCache(key);
            if (bresult == null)
            {
                bresult = GetPermissionDB(Convert.ToString((int)userPerType), HttpContext.Current.Session["User.UserID"].ToString(), HttpContext.Current.Session["User.UserRolID"].ToString(), strDBConnection);
                HttpRuntime.Cache.Insert(key, bresult, null, System.Web.Caching.Cache.NoAbsoluteExpiration, TimeSpan.FromMinutes(5));
            }

            return (bool)bresult;
        }


        /// <summary>
        /// Get permission using HttpContext.Current.Session
        /// </summary>
        /// <param name="userPerType"></param>
        /// <param name="strDBConnection"></param>
        /// <returns></returns>
        public static bool GetPermission(int userPerType, string strDBConnection)
        {
            if (HttpContext.Current.Session["User.UserRolID"].ToString().Equals( "0" )
                || HttpContext.Current.Session["User.UserRolID"].ToString().Equals( "1" ))
            {
                return true;
            }

            var key = HttpContext.Current.Session.SessionID + "_Permission_" + userPerType.ToString();

            var bresult = GetFromCache(key);
            if (bresult == null)
            {
                bresult = GetPermissionDB(userPerType.ToString(), HttpContext.Current.Session["User.UserID"].ToString(), HttpContext.Current.Session["User.UserRolID"].ToString(), strDBConnection);
                HttpRuntime.Cache.Insert(key, bresult, null, System.Web.Caching.Cache.NoAbsoluteExpiration, TimeSpan.FromMinutes(5));
            }

            return (bool)bresult;
        }


        private static bool? GetFromCache(string key)
        {
            if (HttpRuntime.Cache[key] == null)
            {
                return null;
            }
            else
            {
                return Convert.ToBoolean(HttpRuntime.Cache[key].ToString());
            }
        }

        /// <summary>
        /// Get UserPermissionTypeEnum from an string name
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static UserPermissionTypeEnum GetEnumUserPermissionTypeFromStringName(string str)
        {
            UserPermissionTypeEnum c;

            if (Enum.IsDefined(typeof(UserPermissionTypeEnum), str))
            {
                c = (UserPermissionTypeEnum)Enum.Parse(typeof(UserPermissionTypeEnum), str, true);
            }
            else
            {
                c = UserPermissionTypeEnum.NoValidEnum;
            }
            return c;
        }

        /// <summary>
        /// Get rol enum from string rol name
        /// </summary>
        /// <param name="str"></param>
        /// <returns></returns>
        public static UserRolEnum GetEnumUserRolFromStringName(string str)
        {
            UserRolEnum c;

            if (Enum.IsDefined(typeof(UserRolEnum), str))
            {
                c = (UserRolEnum)Enum.Parse(typeof(UserRolEnum), str, true);
            }
            else
            {
                c = UserRolEnum.NoValidEnum;
            }
            return c;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userPerType"></param>
        /// <param name="UserID"></param>
        /// <param name="UserRolID"></param>
        /// <param name="strDBConnection"></param>
        /// <returns></returns>
        private static bool GetPermissionDB(UserPermissionTypeEnum userPerType, string UserID, UserRolEnum UserRolID, string strDBConnection)
        {
            if (UserRolID == UserRolEnum.System || UserRolID == UserRolEnum.SuperAdministrator)
            {
                return true;
            }

            var bReturn = false;
            var strSql = "Permission_QueryUser";


            var paramsToSP = new SqlParameter[] { new SqlParameter("@UserID", UserID )
            ,  new SqlParameter("@UserRolID", UserRolID )
            ,  new SqlParameter("@UserPerTypeId", userPerType )

            };

            var sqlapi = new SqlApiSqlClient();
            using (sqlapi.Connection = new SqlConnection(strDBConnection))
            {
                var reader = sqlapi.DataReaderSqlSP(strSql, paramsToSP);

                if (!reader.HasRows)
                {
                    bReturn = false;
                }
                else
                {
                    if (reader.Read())
                    {
                        if (reader.IsDBNull(0))
                        {
                            bReturn = false;
                        }
                        else
                        {
                            bReturn = Convert.ToBoolean(reader[0]);
                        }
                    }
                    else
                    {
                        bReturn = false;
                    }
                }

                reader.Close();
                sqlapi.Connection.Close();
            }


            return bReturn;
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="userPerType"></param>
        /// <param name="UserID"></param>
        /// <param name="UserRolID"></param>
        /// <param name="strConnection"></param>
        /// <returns></returns>
        private static bool GetPermissionDB(string userPerType, string UserID, string UserRolID, string strConnection)
        {
            if (UserRolID.Equals(Convert.ToString((int)UserRolEnum.System)) || UserRolID.Equals(Convert.ToString((int)UserRolEnum.SuperAdministrator)))
            {
                return true;
            }

            var bReturn = false;
            var strSql = "EXEC Permission_QueryUser @UserID, @UserRolID, @UserPerTypeId ;";
            
            var paramsToSP = new SqlParameter[] { 
             new SqlParameter() { ParameterName="@UserID", DbType= DbType.Int32, Value= UserID}
            ,new SqlParameter() { ParameterName="@UserRolID", DbType= DbType.Int32, Value= UserRolID}
            ,new SqlParameter() { ParameterName="@UserPerTypeId", DbType= DbType.Int32, Value= userPerType}

            };


            bReturn = SqlApiSqlClient.GetBitRecordValue(strSql, paramsToSP, strConnection);


            /*
            var sqlapi = new SqlApiSqlClient();
            using (sqlapi.Connection = new SqlConnection(strConnection))
            {
                var reader = sqlapi.DataReaderSqlSP(strSql, paramsToSP);

                if (!reader.HasRows)
                {
                    bReturn = false;
                }
                else
                {
                    if (reader.Read())
                    {
                        if (reader.IsDBNull(0))
                        {
                            bReturn = false;
                        }
                        else
                        {
                            bReturn = Convert.ToBoolean(reader[0]);
                        }
                    }
                    else
                    {
                        bReturn = false;
                    }
                }

                reader.Close();
                sqlapi.Connection.Close();
            }
            */

            return bReturn;
        }
    }
}
