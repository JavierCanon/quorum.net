﻿using System;
using System.Web;
using System.Web.UI.WebControls;
using QuorumWeb.SL;
using QuorumWeb.Enums;



namespace QuorumWeb.UI
{
    public abstract class PageBase : PageBaseCommon
    {
        public string PageTitle = ""; // variable for controls can access early to page title before render.


        #region Security
        public static bool SecurityCanInsert;
        public static bool SecurityCanUpdate;
        public static bool SecurityCanDelete;


        #endregion Security

        protected new void Page_PreInit(object sender, EventArgs e)
        {
            base.Page_PreInit(sender, e);


        }


        /// <summary>
        /// valida sesion.
        /// </summary>
        /// <param name="e"></param>
        protected new void OnPreInit(EventArgs e)
        {
            base.OnPreInit(e);

        }

        protected new void Page_OnInit(EventArgs e)
        {
            base.Page_OnInit(e);

        }


        /// <summary>
        ///
        /// </summary>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        protected new void Page_Init(object sender, EventArgs e)
        {
            base.Page_Init(sender, e);


            SetDeveloperVariables();

            if (!CheckIsValidSession())
            {
                if (IsCallback)
                {
                    Response.RedirectLocation = ResolveUrl("~/Views/Login.aspx?ReturnUrl=" + Request.RawUrl);
                }
                else
                {
                    Response.Redirect("~/Views/Login.aspx?ReturnUrl=" + Request.RawUrl);
                }
            }

            Response.Cache.SetCacheability(HttpCacheability.NoCache);

        }


        protected new void Page_OnInitComplete(EventArgs e)
        {
            base.Page_OnInitComplete(e);


        }

        protected new void Page_Load(object sender, EventArgs e)
        {
            base.Page_Load(sender, e);

        }

        protected void Page_PreRender(object sender, EventArgs e)
        {
            // set page title
            if (string.IsNullOrEmpty(Page.Header.Title))
            {
                Page.Title = this.PageTitle;

            }
        }



        /// <summary>
        /// chequea que la sessión sea valida, si no redirecciona al login.
        /// </summary>
        virtual protected void CheckSession()
        {
           // if (Session["User.UserID"] == null)
           if(!Global.Sessions.GetIsValidSession())
            {
                Session.Clear();
                Session.Abandon();
                Response.Redirect("~/Views/Login.aspx?ReturnUrl=" + Request.RawUrl);
            }
        }

        /// <summary>
        ///
        /// </summary>
        /// <returns></returns>
        virtual protected bool CheckIsValidSession()
        {
            return Global.Sessions.GetIsValidSession();

            /*
            if (Session["User.UserID"] != null)
            {
                return true;
            }
            else
            {
                return false;
            }*/
        }

        /// <summary>
        /// variables adicionales para debug.
        /// </summary>
        public void SetDeveloperVariables()
        {
            if (GetIsDeveloperMode())
            {
            }
        }


        #region Datasources

        protected void DatasourcesCachesInit(string skey)
        {
            // CACHE
            if (Cache[skey] == null)
            {
                Cache[skey] = DateTime.Now;
            }
        }

        protected void DatasourcesCachesInvalidate(string skey)
        {
            // CACHE
            if (Cache[skey] != null)
            {
                Cache[skey] = DateTime.Now;
            }

        }


        #endregion Datasources



        #region User Session

        public string ShowUserQueriesFilterData()
        {

            if (Context.Session["User.UserQueriesFilterData"] != null)
            {

                string text = Context.Session["User.UserQueriesFilterData"].ToString();

                if (!string.IsNullOrEmpty(text))
                    return string.Format(
                        "<div class=\"alert alert-warning alert-dismissible\" role=\"alert\"> <button type=\"button\" class=\"close\" data-dismiss=\"alert\" aria-label=\"Close\"><span aria-hidden=\"true\">&times;</span></button> <strong>Filtro Fijo de Usuario: </strong> {0}.</div>"
                        , text);
                else
                    return "";

            }

            return "";
        }



        #endregion UserSession



        #region Security

        public string SecurityGetDisableClass(UserActionsEnum action)
        {
            if (action == UserActionsEnum.Insert)
            {
                if (SecurityCanInsert)
                {
                    return string.Empty;
                }
                else
                {
                    return "disabled";
                }
            }

            if (action == UserActionsEnum.Update)
            {
                if (SecurityCanUpdate)
                {
                    return string.Empty;
                }
                else
                {
                    return "disabled";
                }
            }

            if (action == UserActionsEnum.Delete)
            {
                if (SecurityCanDelete)
                {
                    return string.Empty;
                }
                else
                {
                    return "disabled";
                }
            }

            return string.Empty;
        }
        #endregion Security


    }
}
