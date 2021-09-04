package consortion.view
{
   import com.pickgliss.events.FrameEvent;
   import com.pickgliss.ui.ComponentFactory;
   import com.pickgliss.ui.LayerManager;
   import com.pickgliss.ui.controls.Frame;
   import com.pickgliss.ui.controls.ListPanel;
   import com.pickgliss.ui.controls.ScrollPanel;
   import com.pickgliss.ui.controls.TextButton;
   import com.pickgliss.ui.controls.container.VBox;
   import com.pickgliss.ui.image.MutipleImage;
   import com.pickgliss.ui.text.FilterFrameText;
   import com.pickgliss.utils.ObjectUtils;
   import consortion.ConsortionModel;
   import consortion.ConsortionModelControl;
   import consortion.consortionTask.ConsortionCampaignListItem;
   import consortion.event.ConsortionEvent;
   import consortion.event.ConsortionMonsterEvent;
   import consortion.managers.ConsortionMonsterManager;
   import ddt.events.CrazyTankSocketEvent;
   import ddt.manager.LanguageMgr;
   import ddt.manager.PlayerManager;
   import ddt.manager.ServerConfigManager;
   import ddt.manager.SocketManager;
   import ddt.manager.SoundManager;
   import ddt.manager.TimeManager;
   import ddt.view.UIModuleSmallLoading;
   import flash.events.Event;
   import road7th.comm.PackageIn;
   
   public class ConsortionCampaign extends Frame
   {
       
      
      private var _remainTimeText:FilterFrameText;
      
      private var _publishBtn:TextButton;
      
      private var _getMissionBtn:TextButton;
      
      private var _goTransportBtn:TextButton;
      
      private var _campaignList:ListPanel;
      
      private var _bg:MutipleImage;
      
      private var _itemList:Vector.<ConsortionCampaignListItem>;
      
      private var _itemPanel:ScrollPanel;
      
      private var _itemVBox:VBox;
      
      public function ConsortionCampaign()
      {
         super();
         escEnable = true;
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
      }
      
      private function __init(param1:CrazyTankSocketEvent) : void
      {
         this.__onClose();
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:int = _loc2_.readInt();
         var _loc4_:int = _loc2_.readInt();
         var _loc5_:int = _loc2_.readInt();
         var _loc6_:Date = _loc2_.readDate();
         var _loc7_:Date = _loc2_.readDate();
         var _loc8_:Boolean = _loc2_.readBoolean();
         var _loc9_:int = _loc2_.readInt();
         var _loc10_:int = _loc2_.readInt();
         ConsortionModelControl.Instance.model.lastPublishDate = _loc6_;
         ConsortionModelControl.Instance.model.receivedQuestCount = _loc9_;
         ConsortionModelControl.Instance.model.consortiaQuestCount = _loc10_;
         PlayerManager.Instance.Self.consortiaInfo.Level = _loc3_;
         ConsortionModelControl.Instance.model.isMaster = _loc8_;
         ConsortionModelControl.Instance.model.currentTaskLevel = _loc5_;
         ConsortionModelControl.Instance.model.remainPublishTime = ConsortionModelControl.Instance.model.getLevelData(_loc3_).QuestCount - _loc4_;
         if(_loc6_.valueOf() == _loc7_.valueOf() || _loc5_ == 0 || _loc4_ == 0 || !this.checkPublishEnable() || _loc10_ >= ServerConfigManager.instance.getConsortiaTaskAcceptMax() || _loc9_ >= ConsortionModelControl.Instance.model.getLevelData(_loc3_).Count * 5)
         {
            ConsortionModelControl.Instance.model.canAcceptTask = false;
         }
         else
         {
            ConsortionModelControl.Instance.model.canAcceptTask = true;
         }
         this.initView();
         this.initEvent();
      }
      
      private function checkPublishEnable() : Boolean
      {
         var _loc1_:Date = ConsortionModelControl.Instance.model.lastPublishDate;
         var _loc2_:Date = TimeManager.Instance.Now();
         if(_loc2_.getFullYear() > _loc1_.getFullYear())
         {
            return true;
         }
         if(_loc2_.getMonth() > _loc1_.getMonth())
         {
            return true;
         }
         if(_loc2_.getDate() >= _loc1_.getDate())
         {
            return true;
         }
         return false;
      }
      
      private function __reflashTaskItem(param1:ConsortionEvent) : void
      {
         var _loc2_:ConsortionCampaignListItem = null;
         for each(_loc2_ in this._itemList)
         {
            if(int(_loc2_.getCellValue()) == ConsortionModel.CONSORTION_TASK)
            {
               _loc2_.reflashBtnByTpye(false);
            }
         }
      }
      
      private function __updateAcceptQuestTime(param1:CrazyTankSocketEvent) : void
      {
         var _loc5_:ConsortionCampaignListItem = null;
         var _loc2_:PackageIn = param1.pkg as PackageIn;
         var _loc3_:Date = _loc2_.readDate();
         var _loc4_:int = _loc2_.readInt();
         ConsortionModelControl.Instance.model.consortiaQuestCount = _loc4_;
         for each(_loc5_ in this._itemList)
         {
            if(int(_loc5_.getCellValue()) == ConsortionModel.CONSORTION_TASK)
            {
               ConsortionModelControl.Instance.model.canAcceptTask = false;
               _loc5_.reflashBtnByTpye(false);
            }
         }
      }
      
      private function initView() : void
      {
         titleText = LanguageMgr.GetTranslation("consortion.consortionCampaign.title.text");
         this._bg = ComponentFactory.Instance.creatComponentByStylename("consortionCampaign.ListBG");
         addToContent(this._bg);
         this._itemList = new Vector.<ConsortionCampaignListItem>();
         this._itemVBox = ComponentFactory.Instance.creat("consortion.ConsortionCampaign.campaignVBox");
         this._itemPanel = ComponentFactory.Instance.creat("consortion.ConsortionCampaign.campaignScroll");
         this._itemPanel.setView(this._itemVBox);
         this._itemVBox.beginChanges();
         var _loc1_:ConsortionCampaignListItem = new ConsortionCampaignListItem(ConsortionModel.CONSORTION_TASK);
         var _loc2_:ConsortionCampaignListItem = new ConsortionCampaignListItem(ConsortionModel.CONSORTION_CONVOY);
         var _loc3_:ConsortionCampaignListItem = new ConsortionCampaignListItem(ConsortionModel.MONSTER_REFLASH);
         if(ConsortionMonsterManager.Instance.ActiveState)
         {
            _loc3_.setBtnEnable();
         }
         else
         {
            _loc3_.setBtnEnable(false);
         }
         this._itemList.push(_loc1_);
         this._itemList.push(_loc2_);
         this._itemList.push(_loc3_);
         this._itemVBox.addChild(_loc1_);
         this._itemVBox.addChild(_loc2_);
         this._itemVBox.addChild(_loc3_);
         this._itemVBox.commitChanges();
         this._itemPanel.invalidateViewport();
         addToContent(this._itemPanel);
      }
      
      private function initEvent() : void
      {
         addEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         ConsortionMonsterManager.Instance.addEventListener(ConsortionMonsterEvent.MONSTER_ACTIVE_START,this.__onActiveStarted);
      }
      
      private function __onActiveStarted(param1:ConsortionMonsterEvent) : void
      {
         if(param1.data as Boolean)
         {
            this._itemList[2].setBtnEnable();
         }
         else
         {
            this._itemList[2].setBtnEnable(false);
         }
      }
      
      private function __responseHandler(param1:FrameEvent) : void
      {
         if(param1.responseCode == FrameEvent.CLOSE_CLICK || param1.responseCode == FrameEvent.ESC_CLICK)
         {
            SoundManager.instance.play("008");
            this.dispose();
         }
      }
      
      public function show() : void
      {
         LayerManager.Instance.addToLayer(this,LayerManager.GAME_DYNAMIC_LAYER,true,LayerManager.BLCAK_BLOCKGOUND);
         UIModuleSmallLoading.Instance.progress = 0;
         UIModuleSmallLoading.Instance.show();
         UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE,this.__onClose);
      }
      
      private function __onClose(param1:Event = null) : void
      {
         UIModuleSmallLoading.Instance.hide();
         UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE,this.__onClose);
      }
      
      override public function dispose() : void
      {
         removeEventListener(FrameEvent.RESPONSE,this.__responseHandler);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_UPDATE_QUEST,this.__init);
         SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REQUEST_CONSORTIA_QUEST,this.__updateAcceptQuestTime);
         ConsortionModelControl.Instance.removeEventListener(ConsortionEvent.REFLASH_CAMPAIGN_ITEM,this.__reflashTaskItem);
         ConsortionMonsterManager.Instance.removeEventListener(ConsortionMonsterEvent.MONSTER_ACTIVE_START,this.__onActiveStarted);
         ObjectUtils.disposeObject(this._remainTimeText);
         this._remainTimeText = null;
         ObjectUtils.disposeObject(this._publishBtn);
         this._publishBtn = null;
         ObjectUtils.disposeObject(this._getMissionBtn);
         this._getMissionBtn = null;
         ObjectUtils.disposeObject(this._goTransportBtn);
         this._goTransportBtn = null;
         ObjectUtils.disposeObject(this._campaignList);
         this._campaignList = null;
         ObjectUtils.disposeObject(this._bg);
         this._bg = null;
         ObjectUtils.disposeObject(this._itemVBox);
         this._itemVBox = null;
         ObjectUtils.disposeObject(this._itemPanel);
         this._itemPanel = null;
         ObjectUtils.disposeObject(this._itemList);
         this._itemList = null;
         super.dispose();
      }
   }
}
