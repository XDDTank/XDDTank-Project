package platformapi.tencent.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.core.Disposeable;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.utils.ClassUtils;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.data.DailyAwardType;
   import ddt.manager.PlayerManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.MovieClip;
   import flash.events.MouseEvent;
   
   public class BunAwardFrame extends Frame implements Disposeable
   {
       
      
      private var _titlebg:Bitmap;
      
      private var _bg:MutipleImage;
      
      private var _decribe:MovieClip;
      
      private var _getBtn:SimpleBitmapButton;
      
      private var _vbox:VBox;
      
      private var _itmes:Array;
      
      public function BunAwardFrame()
      {
         super();
         this.initEvent();
      }
      
      override protected function init() : void
      {
         super.init();
         this._titlebg = ComponentFactory.Instance.creatBitmap("asset.MemberDiamondGift.bun.title");
         addToContent(this._titlebg);
         this._bg = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.BunAwardFrame.bg");
         addToContent(this._bg);
         this._decribe = ClassUtils.CreatInstance("asset.MemberDiamondGift.bun.describe");
         PositionUtils.setPos(this._decribe,"asset.MemberDiamondGift.bun.describePos");
         addToContent(this._decribe);
         this._vbox = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.BunAwardFrame.vbox");
         addToContent(this._vbox);
         this.createItem();
         this._getBtn = ComponentFactory.Instance.creatComponentByStylename("memberDiamondGift.view.BunAwardFrame.getBtn");
         this._getBtn.enable = PlayerManager.Instance.Self.canTakeLevel3366Pack;
         addToContent(this._getBtn);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this._frameResponse);
         this._getBtn.addEventListener(MouseEvent.CLICK,this._getBtnClick);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this._frameResponse);
         this._getBtn.removeEventListener(MouseEvent.CLICK,this._getBtnClick);
      }
      
      private function createItem() : void
      {
         var _loc2_:BunAwardItem = null;
         this._itmes = [];
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            _loc2_ = new BunAwardItem(_loc1_ + 1);
            this._vbox.addChild(_loc2_);
            this._itmes.push(_loc2_);
            _loc1_++;
         }
      }
      
      private function clearItem() : void
      {
         var _loc1_:int = 0;
         while(_loc1_ < 6)
         {
            this._itmes[_loc1_].dispose();
            this._itmes[_loc1_] = null;
            _loc1_++;
         }
      }
      
      private function _getBtnClick(param1:MouseEvent) : void
      {
         SoundManager.instance.play("008");
         SocketManager.Instance.out.sendDiamondAward(DailyAwardType.BunAward);
         this._getBtn.visible = PlayerManager.Instance.Self.canTakeLevel3366Pack = false;
         this.dispose();
      }
      
      private function _frameResponse(param1:FrameEvent) : void
      {
         switch(param1.responseCode)
         {
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               SoundManager.instance.play("008");
               this.dispose();
         }
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.clearItem();
         ObjectUtils.disposeObject(this._titlebg);
         this._titlebg = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._decribe);
         this._decribe = null;
         ObjectUtils.disposeObject(this._getBtn);
         this._getBtn = null;
         ObjectUtils.disposeObject(this._vbox);
         this._vbox = null;
         ObjectUtils.disposeObject(this._itmes);
         this._vbox = null;
      }
   }
}
