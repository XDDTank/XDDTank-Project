package worldboss.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.toplevel.StageReferance;
   import com.pickgliss.ui.AlertManager;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.ScaleFrameImage;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import flash.display.Bitmap;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   public class RoomMenuView extends Sprite implements Disposeable
   {
       
      
      private var _menuIsOpen:Boolean = true;
      
      private var _BG:Bitmap;
      
      private var _closeBtn:SimpleBitmapButton;
      
      private var _switchIMG:ScaleFrameImage;
      
      private var _returnBtn:SimpleBitmapButton;
      
      private var _leaveMsg:String;
      
      private var _alert:BaseAlerFrame;
      
      public function RoomMenuView()
      {
         super();
         this.initialize();
      }
      
      public function set leaveMsg(param1:String) : void
      {
         this._leaveMsg = param1;
      }
      
      private function initialize() : void
      {
         this._BG = ComponentFactory.Instance.creatBitmap("asset.worldBossRoom.menuBG");
         addChild(this._BG);
         this._closeBtn = ComponentFactory.Instance.creatComponentByStylename("asset.worldBossRoom.switchBtn");
         addChild(this._closeBtn);
         this._switchIMG = ComponentFactory.Instance.creatComponentByStylename("asset.worldBossRoom.switchIMG");
         this._switchIMG.setFrame(1);
         this._closeBtn.addChild(this._switchIMG);
         this._returnBtn = ComponentFactory.Instance.creatComponentByStylename("asset.worldBossRoom.returnBtn");
         addChild(this._returnBtn);
         this.setEvent();
      }
      
      private function setEvent() : void
      {
         this._returnBtn.addEventListener(MouseEvent.CLICK,this.backRoomList);
         this._closeBtn.addEventListener(MouseEvent.CLICK,this.switchMenu);
      }
      
      private function backRoomList(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         this._alert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("AlertDialog.Info"),LanguageMgr.GetTranslation(this._leaveMsg),LanguageMgr.GetTranslation("ok"),LanguageMgr.GetTranslation("cancel"),false,false,false,LayerManager.ALPHA_BLOCKGOUND);
         this._alert.addEventListener(FrameEvent.RESPONSE,this.__frameResponse);
      }
      
      private function __frameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         var _loc2_:Frame = param1.target as Frame;
         _loc2_.removeEventListener(FrameEvent.RESPONSE,this.__frameResponse);
         switch(param1.responseCode)
         {
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               SocketManager.Instance.out.sendLeaveBossRoom();
               SoundManager.instance.play("008");
               dispatchEvent(new Event(Event.CLOSE));
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               _loc2_.dispose();
         }
      }
      
      private function switchMenu(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         if(this._menuIsOpen)
         {
            this._switchIMG.setFrame(2);
         }
         else
         {
            this._switchIMG.setFrame(1);
         }
         addEventListener(Event.ENTER_FRAME,this.menuShowOrHide);
      }
      
      private function menuShowOrHide(param1:Event) : void
      {
         var _loc2_:int = 0;
         _loc2_ = 34;
         if(this._menuIsOpen)
         {
            this.x += 20;
            if(this.x >= StageReferance.stageWidth - _loc2_)
            {
               removeEventListener(Event.ENTER_FRAME,this.menuShowOrHide);
               this.x = StageReferance.stageWidth - _loc2_;
               this._menuIsOpen = false;
            }
         }
         else
         {
            this.x -= 20;
            if(this.x <= StageReferance.stageWidth - this.width)
            {
               removeEventListener(Event.ENTER_FRAME,this.menuShowOrHide);
               this.x = StageReferance.stageWidth - this.width + 5;
               this._menuIsOpen = true;
            }
         }
      }
      
      public function dispose() : void
      {
         var _loc1_:Object = null;
         ObjectUtils.disposeObject(this._BG);
         this._BG = null;
         ObjectUtils.disposeObject(this._closeBtn);
         this._closeBtn = null;
         ObjectUtils.disposeObject(this._switchIMG);
         this._switchIMG = null;
         ObjectUtils.disposeObject(this._returnBtn);
         this._returnBtn = null;
         ObjectUtils.disposeObject(this._alert);
         this._alert = null;
         while(numChildren > 0)
         {
            _loc1_ = getChildAt(0);
            ObjectUtils.disposeObject(_loc1_);
            _loc1_ = null;
         }
         if(this.parent)
         {
            this.parent.removeChild(this);
         }
      }
   }
}
