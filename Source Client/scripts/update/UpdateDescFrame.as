package update
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.alert.BaseAlerFrame;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.ui.vo.AlertInfo;
   import com.pickgliss.utils.ObjectUtils;
   import ddt.manager.LanguageMgr;
   import ddt.manager.SharedManager;
   import ddt.manager.SoundManager;
   import ddt.utils.PositionUtils;
   import flash.display.Bitmap;
   import flash.display.DisplayObject;
   import update.data.PopSysNoticeBaseInfo;
   import update.data.PopSysNoticeContentInfo;
   
   public class UpdateDescFrame extends BaseAlerFrame
   {
       
      
      private var _titleInfo:PopSysNoticeBaseInfo;
      
      private var _contentInfo:Vector.<PopSysNoticeContentInfo>;
      
      private var _alertInfo:AlertInfo;
      
      private var _itemPanel:ScrollPanel;
      
      private var _itemVBox:VBox;
      
      private var _bigTitle:FilterFrameText;
      
      private var _updateTimeTxt:FilterFrameText;
      
      private var _bg:DisplayObject;
      
      private var _titleBG:Bitmap;
      
      public function UpdateDescFrame()
      {
         super();
         this.initView();
         this.addEvent();
      }
      
      private function initView() : void
      {
         var _loc2_:PopSysNoticeContentInfo = null;
         var _loc3_:uint = 0;
         var _loc4_:VBox = null;
         var _loc5_:FilterFrameText = null;
         var _loc6_:FilterFrameText = null;
         this._alertInfo = new AlertInfo();
         this._alertInfo.title = LanguageMgr.GetTranslation("ddt.update.frame.title");
         this._alertInfo.moveEnable = false;
         this._alertInfo.showCancel = false;
         info = this._alertInfo;
         this._bg = ComponentFactory.Instance.creat("updateFrame.BG");
         addToContent(this._bg);
         this._titleBG = ComponentFactory.Instance.creatBitmap("asset.core.newFrame.titleBg");
         addToContent(this._titleBG);
         this._titleInfo = UpdateController.Instance.lastNoticeBase;
         this._contentInfo = new Vector.<PopSysNoticeContentInfo>();
         var _loc1_:Array = UpdateController.Instance.noticeContentList;
         if(this._titleInfo && _loc1_ && _loc1_.length > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc1_.length)
            {
               if(_loc1_[_loc3_].ID == this._titleInfo.ID)
               {
                  this._contentInfo.push(_loc1_[_loc3_]);
               }
               _loc3_++;
            }
            this._contentInfo.sort(this.sortContentInfo);
         }
         this._bigTitle = ComponentFactory.Instance.creatComponentByStylename("updateFrame.bigTitle.txt");
         this._updateTimeTxt = ComponentFactory.Instance.creatComponentByStylename("updateFrame.content.txt");
         if(this._titleInfo)
         {
            this._bigTitle.text = this._titleInfo.Title;
            SharedManager.Instance.showUpdateFrameDate = this._titleInfo.BeginTime;
            this._updateTimeTxt.text = LanguageMgr.GetTranslation("ddt.update.frame.updateTime") + ":" + this._titleInfo.BeginTime.split(" ")[0];
         }
         PositionUtils.setPos(this._updateTimeTxt,"update.frame.updateTime.pos");
         addToContent(this._updateTimeTxt);
         addToContent(this._bigTitle);
         this._itemPanel = ComponentFactory.Instance.creatComponentByStylename("updateFrame.listPanel");
         this._itemVBox = ComponentFactory.Instance.creatComponentByStylename("updateFrame.listVbox");
         this._itemPanel.setView(this._itemVBox);
         this._itemVBox.beginChanges();
         for each(_loc2_ in this._contentInfo)
         {
            _loc4_ = ComponentFactory.Instance.creatComponentByStylename("updateFrame.smallInfoVbox");
            _loc4_.beginChanges();
            _loc5_ = ComponentFactory.Instance.creatComponentByStylename("updateFrame.smallTitle.txt");
            _loc6_ = ComponentFactory.Instance.creatComponentByStylename("updateFrame.content.txt");
            _loc5_.text = _loc2_.LineTitle;
            _loc6_.text = _loc2_.Content;
            _loc4_.addChild(_loc5_);
            _loc4_.addChild(_loc6_);
            _loc4_.commitChanges();
            this._itemVBox.addChild(_loc4_);
         }
         this._itemVBox.commitChanges();
         this._itemPanel.invalidateViewport();
         addToContent(this._itemPanel);
      }
      
      private function sortContentInfo(param1:PopSysNoticeContentInfo, param2:PopSysNoticeContentInfo) : int
      {
         if(param1.Order >= param2.Order)
         {
            return 1;
         }
         return -1;
      }
      
      private function addEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function removeEvent() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.onFrameResponse);
      }
      
      private function onFrameResponse(param1:FrameEvent) : void
      {
         SoundManager.instance.play("008");
         switch(param1.responseCode)
         {
            case FrameEvent.CANCEL_CLICK:
            case FrameEvent.CLOSE_CLICK:
            case FrameEvent.ESC_CLICK:
               this.dispose();
               break;
            case FrameEvent.ENTER_CLICK:
            case FrameEvent.SUBMIT_CLICK:
               this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         SharedManager.Instance.hasShowUpdateFrame = true;
      }
      
      override public function dispose() : void
      {
         super.dispose();
         this.removeEvent();
         this._titleInfo = null;
         this._contentInfo = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._alertInfo);
         this._alertInfo = null;
         ObjectUtils.disposeObject(this._itemVBox);
         this._itemVBox = null;
         ObjectUtils.disposeObject(this._itemPanel);
         this._itemPanel = null;
         ObjectUtils.disposeObject(this._bigTitle);
         this._bigTitle = null;
         ObjectUtils.disposeObject(this._updateTimeTxt);
         this._updateTimeTxt = null;
         ObjectUtils.disposeObject(this._titleBG);
         this._titleBG = null;
      }
   }
}
