// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.view.EmailEvent

package email.view
{
    import flash.events.Event;
    import email.data.EmailInfo;
    import ddt.data.goods.ItemTemplateInfo;

    public class EmailEvent extends Event 
    {

        public static const ADD_EMAIL:String = "addEmail";
        public static const REMOVE_EMAIL:String = "removeEmail";
        public static const INIT_EMAIL:String = "initEmail";
        public static const CHANGE_EMAIL:String = "changeEmail";
        public static const CLEAR_EMAIL:String = "clearEmail";
        public static const SELECT_EMAIL:String = "selectEmail";
        public static const CHANE_STATE:String = "changeState";
        public static const CHANE_PAGE:String = "changePage";
        public static const CHANG_MODEL:String = "changeModel";
        public static const CHANGE_TYPE:String = "changeType";
        public static const SIGN_MAIL_READ:String = "sign mail to read";
        public static const DRAGIN_BAG:String = "draginBag";
        public static const DRAGOUT_BAG:String = "dragoutBag";
        public static const ESCAPE_KEY:String = "escapeKey";
        public static const CLOSE_WRITING_FRAME:String = "closeWritingFrame";
        public static const DISPOSED:String = "disposed";
        public static const BAG_UPDATA:String = "bag_upData";

        private var _info:EmailInfo;
        private var _item:ItemTemplateInfo;

        public function EmailEvent(_arg_1:String, _arg_2:Object=null, _arg_3:Boolean=false, _arg_4:Boolean=false)
        {
            super(_arg_1, _arg_3, _arg_4);
            this._info = (_arg_2 as EmailInfo);
            this._item = (_arg_2 as ItemTemplateInfo);
        }

        public function get info():EmailInfo
        {
            return (this._info);
        }

        public function get item():ItemTemplateInfo
        {
            return (this._item);
        }


    }
}//package email.view

