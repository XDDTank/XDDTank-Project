// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//ddt.manager.PageInterfaceManager

package ddt.manager
{
    import flash.external.ExternalInterface;

    public class PageInterfaceManager 
    {


        public static function changePageTitle(_arg_1:String):void
        {
            if (((ExternalInterface.available) && (!(DesktopManager.Instance.isDesktop))))
            {
                ExternalInterface.call("title_effect.tickerBegin", LanguageMgr.GetTranslation("pageInterface.yourturn"));
            };
        }

        public static function restorePageTitle():void
        {
            if (((ExternalInterface.available) && (!(DesktopManager.Instance.isDesktop))))
            {
                ExternalInterface.call("title_effect.tickerStop", StatisticManager.siteName);
            };
        }

        public static function askForFavorite():void
        {
            if (((ExternalInterface.available) && (!(DesktopManager.Instance.isDesktop))))
            {
                ExternalInterface.call("AddFavorite", PathManager.solveLogin());
            };
        }

        private static function call(_arg_1:String, ... _args):void
        {
            if (((ExternalInterface.available) && (!(DesktopManager.Instance.isDesktop))))
            {
                ExternalInterface.call(_arg_1, _args);
            };
        }


    }
}//package ddt.manager

