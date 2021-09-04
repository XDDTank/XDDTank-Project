package platformapi.tencent.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.SimpleBitmapButton;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.HBox;
   import com.pickgliss.ui.image.Scale9CornerImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SoundManager;
   import ddt.utils.RequestVairableCreater;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   import flash.net.URLVariables;
   
   public class ListenWeiboFrame extends BaseAlerFrame
   {
       
      
      private var _title1:Bitmap;
      
      private var _title2:Bitmap;
      
      private var _BG1:Scale9CornerImage;
      
      private var _BG2:Scale9CornerImage;
      
      private var _BG3:Bitmap;
      
      private var _desc:FilterFrameText;
      
      private var _cells:HBox;
      
      private var _listenBtn:SimpleBitmapButton;
      
      private var _line:Bitmap;
      
      public function ListenWeiboFrame()
      {
         super();
      }
      
      override protected function init() : void
      {
         super.init();
         var _loc1_:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.view.ListenWeiboFrame.title"));
         _loc1_.bottomGap = 10;
         info = _loc1_;
         this._BG1 = ComponentFactory.Instance.creatComponentByStylename("ListenWeiboFrame.core.scale9CornerImage22");
         addToContent(this._BG1);
         this._BG2 = ComponentFactory.Instance.creatComponentByStylename("ListenWeiboFrame.core.BG2");
         addToContent(this._BG2);
         this._BG3 = ComponentFactory.Instance.creatBitmap("ddt.view.ListenWeiboFrame.cellBG");
         addToContent(this._BG3);
         this._title1 = ComponentFactory.Instance.creatBitmap("ddt.view.ListenWeiboFrame.title1");
         addToContent(this._title1);
         this._title2 = ComponentFactory.Instance.creatBitmap("ddt.view.ListenWeiboFrame.title2");
         addToContent(this._title2);
         this._desc = ComponentFactory.Instance.creatComponentByStylename("ListenWeiboFrame.core.desc");
         this._desc.text = LanguageMgr.GetTranslation("ddt.view.ListenWeiboFrame.desc");
         addToContent(this._desc);
         this._listenBtn = ComponentFactory.Instance.creatComponentByStylename("ListenWeiboFrame.core.view.ListenBtn");
         addToContent(this._listenBtn);
         this._line = ComponentFactory.Instance.creatBitmap("ddt.view.ListenWeiboFrame.line");
         addToContent(this._line);
         this._cells = ComponentFactory.Instance.creatComponentByStylename("ListenWeiboFrame.core.hbox");
         addToContent(this._cells);
         this.createCell();
         addEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
         this._listenBtn.addEventListener(MouseEvent.CLICK,this.__onListenClick);
      }
      
      protected function __onListenClick(param1:MouseEvent) : void
      {
         var _loc2_:URLVariables = RequestVairableCreater.creatWidthKey(true);
      }
      
      protected function __onFrameEvent(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.SUBMIT_CLICK:
         }
      }
      
      private function createCell() : void
      {
      }
      
      private function clearCell() : void
      {
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.ALPHA_BLOCKGOUND);
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__onFrameEvent);
         this._listenBtn.removeEventListener(MouseEvent.CLICK,this.__onListenClick);
         this.clearCell();
         ObjectUtils.disposeObject(this._title1);
         this._title1 = null;
         ObjectUtils.disposeObject(this._title2);
         this._title2 = null;
         ObjectUtils.disposeObject(this._BG1);
         this._BG1 = null;
         ObjectUtils.disposeObject(this._BG2);
         this._BG2 = null;
         ObjectUtils.disposeObject(this._BG3);
         this._BG3 = null;
         ObjectUtils.disposeObject(this._desc);
         this._desc = null;
         ObjectUtils.disposeObject(this._cells);
         this._cells = null;
         ObjectUtils.disposeObject(this._listenBtn);
         this._listenBtn = null;
         super.dispose();
         if(this.parent)
         {
            parent.removeChild(this);
         }
      }
   }
}
