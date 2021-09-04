package consortion.view.selfConsortia
{
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.ConsortiaEventInfo;
   import ddt.manager.LanguageMgr;
   import ddt.utils.PositionUtils;
   import flash.display.Sprite;
   
   public class EventListItem extends Sprite implements Disposeable
   {
       
      
      private var _backGroud:ScaleFrameImage;
      
      private var _eventType:ScaleFrameImage;
      
      private var _content:FilterFrameText;
      
      private var _tiemTxt:FilterFrameText;
      
      public function EventListItem()
      {
         super();
         this.initView();
      }
      
      private function initView() : void
      {
         this._backGroud = ComponentFactory.Instance.creatComponentByStylename("eventItem.BG");
         this._eventType = ComponentFactory.Instance.creatComponentByStylename("eventItem.type");
         this._content = ComponentFactory.Instance.creatComponentByStylename("eventItem.content");
         this._tiemTxt = ComponentFactory.Instance.creatComponentByStylename("eventItem.time");
         PositionUtils.setPos(this._tiemTxt,"asset.ddtconsortion.eventTimeTxt");
         addChild(this._backGroud);
         addChild(this._content);
         addChild(this._tiemTxt);
      }
      
      public function updateBaceGroud(param1:int) : void
      {
         if(param1 % 2 != 0)
         {
            this._backGroud.setFrame(2);
         }
         else
         {
            this._backGroud.setFrame(1);
         }
      }
      
      public function set info(param1:ConsortiaEventInfo) : void
      {
         if(param1 == null)
         {
            return;
         }
         var _loc2_:String = param1.Date.toString().split(" ")[0];
         switch(param1.Type)
         {
            case 5:
               this._eventType.setFrame(1);
               if(param1.NickName.toLowerCase() == "gm")
               {
                  this._content.htmlText = LanguageMgr.GetTranslation("ddt.consortia.event.contributeGM",param1.EventValue);
                  this._tiemTxt.text = _loc2_;
               }
               else
               {
                  this._content.htmlText = LanguageMgr.GetTranslation("ddt.consortia.event.contribute",param1.NickName,param1.EventValue);
                  this._tiemTxt.text = _loc2_;
               }
               break;
            case 6:
               this._content.htmlText = LanguageMgr.GetTranslation("ddt.consortia.event.join",param1.ManagerName,param1.NickName);
               this._tiemTxt.text = _loc2_;
               break;
            case 7:
               this._content.htmlText = LanguageMgr.GetTranslation("ddt.consortia.event.quite",param1.ManagerName,param1.NickName);
               this._tiemTxt.text = _loc2_;
               break;
            case 8:
               this._content.htmlText = LanguageMgr.GetTranslation("ddt.consortia.event.quit",param1.NickName);
               this._tiemTxt.text = _loc2_;
               break;
            case 9:
               this._content.htmlText = param1.ManagerName;
               this._tiemTxt.text = _loc2_;
         }
      }
      
      override public function get height() : Number
      {
         return this._backGroud.height;
      }
      
      public function dispose() : void
      {
         ObjectUtils.disposeAllChildren(this);
         this._backGroud = null;
         this._eventType = null;
         this._content = null;
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
