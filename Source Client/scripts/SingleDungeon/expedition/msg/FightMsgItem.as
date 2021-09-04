package SingleDungeon.expedition.msg
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.goods.ItemTemplateInfo;
   import ddt.manager.ItemManager;
   import ddt.manager.LanguageMgr;
   import ddt.utils.Helpers;
   import ddt.view.chat.ChatData;
   import ddt.view.chat.ChatFormats;
   import ddt.view.chat.ChatInputView;
   import flash.display.Sprite;
   
   public class FightMsgItem extends Sprite implements Disposeable
   {
       
      
      private var _msg:FilterFrameText;
      
      private var _info:FightMsgInfo;
      
      public function FightMsgItem()
      {
         super();
         this.initMsg();
      }
      
      public function set info(param1:FightMsgInfo) : void
      {
         this._info = param1;
         this.createMessage();
      }
      
      private function createMessage() : void
      {
         var _loc1_:ItemTemplateInfo = null;
         var _loc2_:ChatData = null;
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         if(this._info.templateID == 1)
         {
            if(this._info.dungeonName)
            {
               this._msg.htmlText = this._info.dungeonName;
            }
            else
            {
               this._msg.htmlText = LanguageMgr.GetTranslation("singledungeon.expedition.fightMsg.text1",this._info.times);
            }
         }
         else if(this._info.templateID == -1)
         {
            this._msg.htmlText = LanguageMgr.GetTranslation("singledungeon.expedition.fightMsg.text4");
         }
         else if(this._info.templateID == -2)
         {
            this._msg.htmlText = LanguageMgr.GetTranslation("singledungeon.expedition.fightMsg.text5");
         }
         else
         {
            _loc1_ = ItemManager.Instance.getTemplateById(this._info.templateID);
            _loc2_ = new ChatData();
            _loc2_.channel = ChatInputView.SYS_TIP;
            _loc3_ = LanguageMgr.GetTranslation("singledungeon.expedition.fightMsg.text2");
            _loc4_ = "";
            _loc5_ = "";
            _loc6_ = "";
            if(this._info.templateID == -100)
            {
               _loc4_ = " " + this._info.count + " ";
               _loc5_ = this._info.name;
               _loc6_ = "";
            }
            else
            {
               _loc4_ = " " + this._info.count + LanguageMgr.GetTranslation("singledungeon.expedition.fightMsg.text3");
               _loc5_ = "<font color=\'#4ea6ff\'>" + ChatFormats.creatBracketsTag("[" + this._info.name + "]",ChatFormats.CLICK_USERNAME) + "</font>";
               _loc6_ = ".";
            }
            _loc2_.htmlMessage = _loc3_ + _loc4_ + _loc5_ + _loc6_;
            this.setChats(_loc2_);
         }
      }
      
      private function setChats(param1:ChatData) : void
      {
         var _loc2_:String = "";
         _loc2_ += Helpers.deCodeString(param1.htmlMessage);
         this._msg.htmlText = "<a>" + _loc2_ + "</a>";
      }
      
      private function initMsg() : void
      {
         this._msg = ComponentFactory.Instance.creatComponentByStylename("singleDungeon.expedition.downFightMsg.text");
         addChild(this._msg);
      }
      
      public function dispose() : void
      {
         if(this._msg)
         {
            ObjectUtils.disposeObject(this._msg);
            this._msg = null;
         }
      }
   }
}
