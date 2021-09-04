package email.view
{
   import ddt.data.goods.ItemTemplateInfo;
   import email.data.EmailInfo;
   import flash.events.Event;
   
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
      
      public function EmailEvent(param1:String, param2:Object = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this._info = param2 as EmailInfo;
         this._item = param2 as ItemTemplateInfo;
      }
      
      public function get info() : EmailInfo
      {
         return this._info;
      }
      
      public function get item() : ItemTemplateInfo
      {
         return this._item;
      }
   }
}
