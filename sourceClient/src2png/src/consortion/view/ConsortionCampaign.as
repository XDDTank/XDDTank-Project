// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.ConsortionCampaign

package consortion.view
{
    import com.pickgliss.ui.controls.Frame;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.controls.ListPanel;
    import com.pickgliss.ui.image.MutipleImage;
    import __AS3__.vec.Vector;
    import consortion.consortionTask.ConsortionCampaignListItem;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.VBox;
    import com.pickgliss.events.FrameEvent;
    import road7th.comm.PackageIn;
    import consortion.ConsortionModelControl;
    import ddt.manager.PlayerManager;
    import ddt.manager.ServerConfigManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.TimeManager;
    import consortion.ConsortionModel;
    import consortion.event.ConsortionEvent;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.ComponentFactory;
    import consortion.managers.ConsortionMonsterManager;
    import consortion.event.ConsortionMonsterEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.view.UIModuleSmallLoading;
    import flash.events.Event;
    import ddt.manager.SocketManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

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
            escEnable = true;
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
        }

        private function __init(_arg_1:CrazyTankSocketEvent):void
        {
            this.__onClose();
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:int = _local_2.readInt();
            var _local_4:int = _local_2.readInt();
            var _local_5:int = _local_2.readInt();
            var _local_6:Date = _local_2.readDate();
            var _local_7:Date = _local_2.readDate();
            var _local_8:Boolean = _local_2.readBoolean();
            var _local_9:int = _local_2.readInt();
            var _local_10:int = _local_2.readInt();
            ConsortionModelControl.Instance.model.lastPublishDate = _local_6;
            ConsortionModelControl.Instance.model.receivedQuestCount = _local_9;
            ConsortionModelControl.Instance.model.consortiaQuestCount = _local_10;
            PlayerManager.Instance.Self.consortiaInfo.Level = _local_3;
            ConsortionModelControl.Instance.model.isMaster = _local_8;
            ConsortionModelControl.Instance.model.currentTaskLevel = _local_5;
            ConsortionModelControl.Instance.model.remainPublishTime = (ConsortionModelControl.Instance.model.getLevelData(_local_3).QuestCount - _local_4);
            if (((((((_local_6.valueOf() == _local_7.valueOf()) || (_local_5 == 0)) || (_local_4 == 0)) || (!(this.checkPublishEnable()))) || (_local_10 >= ServerConfigManager.instance.getConsortiaTaskAcceptMax())) || (_local_9 >= (ConsortionModelControl.Instance.model.getLevelData(_local_3).Count * 5))))
            {
                ConsortionModelControl.Instance.model.canAcceptTask = false;
            }
            else
            {
                ConsortionModelControl.Instance.model.canAcceptTask = true;
            };
            this.initView();
            this.initEvent();
        }

        private function checkPublishEnable():Boolean
        {
            var _local_1:Date = ConsortionModelControl.Instance.model.lastPublishDate;
            var _local_2:Date = TimeManager.Instance.Now();
            if (_local_2.getFullYear() > _local_1.getFullYear())
            {
                return (true);
            };
            if (_local_2.getMonth() > _local_1.getMonth())
            {
                return (true);
            };
            if (_local_2.getDate() >= _local_1.getDate())
            {
                return (true);
            };
            return (false);
        }

        private function __reflashTaskItem(_arg_1:ConsortionEvent):void
        {
            var _local_2:ConsortionCampaignListItem;
            for each (_local_2 in this._itemList)
            {
                if (int(_local_2.getCellValue()) == ConsortionModel.CONSORTION_TASK)
                {
                    _local_2.reflashBtnByTpye(false);
                };
            };
        }

        private function __updateAcceptQuestTime(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_5:ConsortionCampaignListItem;
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            var _local_3:Date = _local_2.readDate();
            var _local_4:int = _local_2.readInt();
            ConsortionModelControl.Instance.model.consortiaQuestCount = _local_4;
            for each (_local_5 in this._itemList)
            {
                if (int(_local_5.getCellValue()) == ConsortionModel.CONSORTION_TASK)
                {
                    ConsortionModelControl.Instance.model.canAcceptTask = false;
                    _local_5.reflashBtnByTpye(false);
                };
            };
        }

        private function initView():void
        {
            titleText = LanguageMgr.GetTranslation("consortion.consortionCampaign.title.text");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("consortionCampaign.ListBG");
            addToContent(this._bg);
            this._itemList = new Vector.<ConsortionCampaignListItem>();
            this._itemVBox = ComponentFactory.Instance.creat("consortion.ConsortionCampaign.campaignVBox");
            this._itemPanel = ComponentFactory.Instance.creat("consortion.ConsortionCampaign.campaignScroll");
            this._itemPanel.setView(this._itemVBox);
            this._itemVBox.beginChanges();
            var _local_1:ConsortionCampaignListItem = new ConsortionCampaignListItem(ConsortionModel.CONSORTION_TASK);
            var _local_2:ConsortionCampaignListItem = new ConsortionCampaignListItem(ConsortionModel.CONSORTION_CONVOY);
            var _local_3:ConsortionCampaignListItem = new ConsortionCampaignListItem(ConsortionModel.MONSTER_REFLASH);
            if (ConsortionMonsterManager.Instance.ActiveState)
            {
                _local_3.setBtnEnable();
            }
            else
            {
                _local_3.setBtnEnable(false);
            };
            this._itemList.push(_local_1);
            this._itemList.push(_local_2);
            this._itemList.push(_local_3);
            this._itemVBox.addChild(_local_1);
            this._itemVBox.addChild(_local_2);
            this._itemVBox.addChild(_local_3);
            this._itemVBox.commitChanges();
            this._itemPanel.invalidateViewport();
            addToContent(this._itemPanel);
        }

        private function initEvent():void
        {
            addEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            ConsortionMonsterManager.Instance.addEventListener(ConsortionMonsterEvent.MONSTER_ACTIVE_START, this.__onActiveStarted);
        }

        private function __onActiveStarted(_arg_1:ConsortionMonsterEvent):void
        {
            if ((_arg_1.data as Boolean))
            {
                this._itemList[2].setBtnEnable();
            }
            else
            {
                this._itemList[2].setBtnEnable(false);
            };
        }

        private function __responseHandler(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.CLOSE_CLICK) || (_arg_1.responseCode == FrameEvent.ESC_CLICK)))
            {
                SoundManager.instance.play("008");
                this.dispose();
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
            UIModuleSmallLoading.Instance.progress = 0;
            UIModuleSmallLoading.Instance.show();
            UIModuleSmallLoading.Instance.addEventListener(Event.CLOSE, this.__onClose);
        }

        private function __onClose(_arg_1:Event=null):void
        {
            UIModuleSmallLoading.Instance.hide();
            UIModuleSmallLoading.Instance.removeEventListener(Event.CLOSE, this.__onClose);
        }

        override public function dispose():void
        {
            removeEventListener(FrameEvent.RESPONSE, this.__responseHandler);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.CONSORTIA_UPDATE_QUEST, this.__init);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.REQUEST_CONSORTIA_QUEST, this.__updateAcceptQuestTime);
            ConsortionModelControl.Instance.removeEventListener(ConsortionEvent.REFLASH_CAMPAIGN_ITEM, this.__reflashTaskItem);
            ConsortionMonsterManager.Instance.removeEventListener(ConsortionMonsterEvent.MONSTER_ACTIVE_START, this.__onActiveStarted);
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
}//package consortion.view

