// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//farm.view.FarmFieldsView

package farm.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import com.pickgliss.toplevel.StageReferance;
    import flash.events.MouseEvent;
    import farm.FarmModelController;
    import farm.event.FarmEvent;
    import ddt.manager.TimeManager;
    import ddt.events.TimeEvents;
    import ddt.manager.SoundManager;
    import com.pickgliss.events.FrameEvent;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.LeavePageManager;
    import ddt.manager.MessageTipManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import farm.model.FieldVO;
    import baglocked.BaglockedManager;
    import ddt.utils.PositionUtils;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.ServerConfigManager;
    import road7th.data.DictionaryData;
    import com.pickgliss.utils.*;
    import __AS3__.vec.*;

    public class FarmFieldsView extends Sprite implements Disposeable 
    {

        private static var FAME_COUNT:int = 9;

        private var _fields:Vector.<FarmFieldBlock>;
        private var _fieldsContainer:Sprite;
        private var _openFlag:FieldOpenFlag;
        private var _alertFrame:BaseAlerFrame;
        private var _seedID:int;
        private var _plantSpeedButton:SimpleBitmapButton;
        private var _plantDeleteButton:SimpleBitmapButton;
        private var _farmRefreshMoney:int;
        private var __farmRefreshTrueMoney:int;
        private var block:FarmFieldBlock;

        public function FarmFieldsView()
        {
            this.initView();
            this.initEvent();
        }

        private function initEvent():void
        {
            StageReferance.stage.addEventListener(MouseEvent.CLICK, this._MouseEventClick);
            FarmModelController.instance.addEventListener(FarmEvent.FIELDS_INFO_READY, this.__fieldInfoReady);
            FarmModelController.instance.addEventListener(FarmEvent.SEED, this.__seeding);
            FarmModelController.instance.addEventListener(FarmEvent.GAIN_FIELD, this.__gainField);
            FarmModelController.instance.addEventListener(FarmEvent.HAS_SEEDING, this.__hasSeeding);
            FarmModelController.instance.addEventListener(FarmEvent.PLANETDELETE, this.__seeding);
            FarmModelController.instance.addEventListener(FarmEvent.PLANTSPEED, this.__seeding);
            this._plantSpeedButton.addEventListener(MouseEvent.CLICK, this.__wantSpeed);
            this._plantDeleteButton.addEventListener(MouseEvent.CLICK, this.__wantDelete);
            TimeManager.addEventListener(TimeEvents.SECONDS, this.__updateByseconds);
            var _local_1:int;
            while (_local_1 < 9)
            {
                this._fields[_local_1].addEventListener(MouseEvent.CLICK, this.__ClickHandler);
                this._fields[_local_1].addEventListener(MouseEvent.ROLL_OVER, this.__onRollOver);
                this._fields[_local_1].addEventListener(MouseEvent.ROLL_OUT, this.__onRollOut);
                _local_1++;
            };
        }

        private function __wantSpeed(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._alertFrame)
            {
                this._alertFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse1);
                this._alertFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse2);
            };
            ObjectUtils.disposeObject(this._alertFrame);
            this.__farmRefreshTrueMoney = (Math.max(Math.ceil(((this.block.info.restSecondTime / 60) / 30)), 1) * this._farmRefreshMoney);
            var _local_2:AlertInfo = new AlertInfo();
            _local_2.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            _local_2.data = LanguageMgr.GetTranslation("store.StoreIIcompose.composeItemView.accelerateAlert1", this.__farmRefreshTrueMoney);
            _local_2.enableHtml = true;
            _local_2.moveEnable = false;
            this._alertFrame = AlertManager.Instance.alert("SimpleAlert", _local_2, LayerManager.ALPHA_BLOCKGOUND);
            this._alertFrame.addEventListener(FrameEvent.RESPONSE, this.__frameResponse1);
        }

        private function __frameResponse1(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                if (PlayerManager.Instance.Self.totalMoney < this.__farmRefreshTrueMoney)
                {
                    this._alertFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse1);
                    this._alertFrame.dispose();
                    LeavePageManager.showFillFrame();
                    return;
                };
                if (this.block.info.isGrownUp)
                {
                    MessageTipManager.getInstance().show(LanguageMgr.GetTranslation("ddt.farm.goFarm.hasGrownUP"));
                    return;
                };
                FarmModelController.instance.farmPlantSpeed(this.block.info.fieldID, this.__farmRefreshTrueMoney);
            };
            this._alertFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse1);
            this._alertFrame.dispose();
        }

        private function __wantDelete(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            if (this._alertFrame)
            {
                this._alertFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse1);
                this._alertFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse2);
            };
            ObjectUtils.disposeObject(this._alertFrame);
            var _local_2:AlertInfo = new AlertInfo();
            _local_2.title = LanguageMgr.GetTranslation("AlertDialog.Info");
            _local_2.data = LanguageMgr.GetTranslation("ddt.farms.killCropComfirmNumPnlTitle");
            _local_2.enableHtml = true;
            _local_2.moveEnable = false;
            this._alertFrame = AlertManager.Instance.alert("SimpleAlert", _local_2, LayerManager.ALPHA_BLOCKGOUND);
            this._alertFrame.addEventListener(FrameEvent.RESPONSE, this.__frameResponse2);
        }

        private function __frameResponse2(_arg_1:FrameEvent):void
        {
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.ENTER_CLICK) || (_arg_1.responseCode == FrameEvent.SUBMIT_CLICK)))
            {
                FarmModelController.instance.farmPlantDelete(this.block.info.fieldID);
            };
            this._alertFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse2);
            this._alertFrame.dispose();
        }

        private function _MouseEventClick(_arg_1:MouseEvent):void
        {
            this._plantDeleteButton.visible = false;
            this._plantSpeedButton.visible = false;
        }

        private function __updateByseconds(_arg_1:TimeEvents):void
        {
            var _local_2:int;
            while (_local_2 < 9)
            {
                if (this._fields[_local_2].info)
                {
                    if (((!(this._fields[_local_2].info.seedID == 0)) && (this._fields[_local_2].info.restSecondTime <= 0)))
                    {
                        if (this._fields[_local_2].plantMovie)
                        {
                            if (this._fields[_local_2].plantMovie.currentFrame == 1)
                            {
                                this._fields[_local_2].info = this._fields[_local_2].info;
                                if ((!(this._fields[_local_2]._gainPlant)))
                                {
                                    this._fields[_local_2].addGainMovice();
                                };
                            };
                        };
                    };
                };
                _local_2++;
            };
        }

        protected function __seeding(_arg_1:FarmEvent):void
        {
            this._fieldsContainer.mouseEnabled = true;
            this._fieldsContainer.mouseChildren = true;
            NewHandContainer.Instance.clearArrowByID(ArrowType.FARM_GUILDE);
            var _local_2:FieldVO = (_arg_1.data as FieldVO);
            this._fields[_local_2.fieldID].info = _local_2;
        }

        protected function __gainField(_arg_1:FarmEvent):void
        {
            var _local_2:FieldVO;
            this._fieldsContainer.mouseEnabled = true;
            this._fieldsContainer.mouseChildren = true;
            _local_2 = (_arg_1.data as FieldVO);
            this._fields[_local_2.fieldID].info.seedID = 0;
            if (this._fields[_local_2.fieldID]._gainPlant)
            {
                this._fields[_local_2.fieldID]._gainPlant.mouseEnabled = false;
                this._fields[_local_2.fieldID]._gainPlant.mouseChildren = false;
                this._fields[_local_2.fieldID]._gainPlant.visible = true;
                this._fields[_local_2.fieldID]._gainPlant.gotoAndPlay(1);
            };
        }

        protected function __ClickHandler(_arg_1:MouseEvent):void
        {
            this.block = (_arg_1.currentTarget as FarmFieldBlock);
            if ((((!(this.block)) || (!(this.block.isDig))) || (this.block.isPlaying)))
            {
                _arg_1.stopImmediatePropagation();
                this._plantDeleteButton.visible = false;
                this._plantSpeedButton.visible = false;
                return;
            };
            SoundManager.instance.play("008");
            if (this.block.info.seedID != 0)
            {
                _arg_1.stopImmediatePropagation();
                if (PlayerManager.Instance.Self.bagLocked)
                {
                    BaglockedManager.Instance.show();
                    return;
                };
                if (this.block.info.isGrownUp)
                {
                    FarmModelController.instance.getHarvest(this.block.info.fieldID);
                    FarmModelController.instance.refreshFarm();
                    this.initEvent();
                };
            };
            if ((((!(this.block.info.isGrownUp)) && (this.block.info.isGrow)) && (this.block.plantMovie["chengzhan"].currentFrame == 73)))
            {
                if (((this._plantSpeedButton) && (this._plantDeleteButton)))
                {
                    this._plantDeleteButton.visible = true;
                    this._plantSpeedButton.visible = true;
                    PositionUtils.setPos(this._plantSpeedButton, ("farm.fieldsView.fieldPos" + this.block.info.fieldID));
                    this._plantSpeedButton.x = (this._plantSpeedButton.x + 35);
                    this._plantSpeedButton.y = (this._plantSpeedButton.y - 64);
                    this._plantDeleteButton.x = (this._plantSpeedButton.x + 53);
                    this._plantDeleteButton.y = this._plantSpeedButton.y;
                };
            }
            else
            {
                this._plantDeleteButton.visible = false;
                this._plantSpeedButton.visible = false;
            };
        }

        protected function __onRollOver(_arg_1:MouseEvent):void
        {
            this.setFilters(false);
            var _local_2:FarmFieldBlock = (_arg_1.target as FarmFieldBlock);
            if (((_local_2) && (_local_2.isDig)))
            {
                _local_2.showLight = true;
            };
            if (_local_2)
            {
                if (_local_2.info)
                {
                    if (_local_2.info.seedID != 0)
                    {
                        _local_2.upTips();
                    };
                };
            };
        }

        protected function __onRollOut(_arg_1:MouseEvent):void
        {
            this.setFilters(false);
        }

        private function remvoeEvent():void
        {
            FarmModelController.instance.removeEventListener(FarmEvent.FIELDS_INFO_READY, this.__fieldInfoReady);
            FarmModelController.instance.removeEventListener(FarmEvent.SEED, this.__seeding);
            FarmModelController.instance.removeEventListener(FarmEvent.GAIN_FIELD, this.__gainField);
            FarmModelController.instance.removeEventListener(FarmEvent.HAS_SEEDING, this.__hasSeeding);
            FarmModelController.instance.removeEventListener(FarmEvent.PLANTSPEED, this.__seeding);
            FarmModelController.instance.removeEventListener(FarmEvent.PLANETDELETE, this.__seeding);
            TimeManager.removeEventListener(TimeEvents.SECONDS, this.__updateByseconds);
            StageReferance.stage.removeEventListener(MouseEvent.CLICK, this._MouseEventClick);
            if (this._alertFrame)
            {
                this._alertFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse1);
                this._alertFrame.removeEventListener(FrameEvent.RESPONSE, this.__frameResponse2);
            };
            var _local_1:int;
            while (_local_1 < FAME_COUNT)
            {
                this._fields[_local_1].removeEventListener(MouseEvent.CLICK, this.__ClickHandler);
                this._fields[_local_1].removeEventListener(MouseEvent.ROLL_OVER, this.__onRollOver);
                this._fields[_local_1].removeEventListener(MouseEvent.ROLL_OUT, this.__onRollOut);
                _local_1++;
            };
        }

        private function initView():void
        {
            var _local_2:FarmFieldBlock;
            this._fieldsContainer = new Sprite();
            this._fields = new Vector.<FarmFieldBlock>(FAME_COUNT);
            var _local_1:int;
            while (_local_1 < FAME_COUNT)
            {
                _local_2 = new FarmFieldBlock(_local_1);
                PositionUtils.setPos(_local_2, ("farm.fieldsView.fieldPos" + _local_1));
                this._fieldsContainer.addChild(_local_2);
                this._fields[_local_1] = _local_2;
                _local_1++;
            };
            addChild(this._fieldsContainer);
            this._openFlag = new FieldOpenFlag();
            this._openFlag.visible = false;
            addChild(this._openFlag);
            this._openFlag.mouseChildren = false;
            this._openFlag.mouseEnabled = false;
            this._plantSpeedButton = ComponentFactory.Instance.creatComponentByStylename("farm.button.speed");
            addChild(this._plantSpeedButton);
            this._plantDeleteButton = ComponentFactory.Instance.creatComponentByStylename("farm.button.delete");
            addChild(this._plantDeleteButton);
            this._plantDeleteButton.visible = false;
            this._plantSpeedButton.visible = false;
            this._plantSpeedButton.tipData = LanguageMgr.GetTranslation("singledungeon.expedition.frame.button.accelerate");
            this._plantDeleteButton.tipData = LanguageMgr.GetTranslation("ddt.farm.killCrop.sure");
            this._farmRefreshMoney = ServerConfigManager.instance.getFarmRefreshMoney();
        }

        private function setFilters(_arg_1:Boolean):void
        {
            var _local_2:FarmFieldBlock;
            for each (_local_2 in this._fields)
            {
                _local_2.showLight = _arg_1;
            };
        }

        protected function __fieldInfoReady(_arg_1:FarmEvent):void
        {
            this.upFields();
            this.upFlagPlace();
        }

        private function __hasSeeding(_arg_1:FarmEvent):void
        {
            var _local_2:int;
            while (_local_2 < FAME_COUNT)
            {
                if (this._fields[_local_2].info.fieldID == FarmModelController.instance.model.seedingFieldInfo.fieldID)
                {
                    this._fields[_local_2].info = FarmModelController.instance.model.seedingFieldInfo;
                    return;
                };
                _local_2++;
            };
        }

        private function upFields():void
        {
            var _local_4:int;
            this._fieldsContainer.mouseEnabled = true;
            this._fieldsContainer.mouseChildren = true;
            var _local_1:Array = [0, 1, 2, 3, 4, 5, 6, 7, 8];
            var _local_2:DictionaryData = FarmModelController.instance.model.fieldsInfo;
            var _local_3:int;
            while (_local_3 < FAME_COUNT)
            {
                this._fields[_local_3].info = _local_2[_local_3];
                _local_3++;
            };
            _local_4 = PlayerManager.Instance.Self.Grade;
            var _local_5:int = ServerConfigManager.instance.getFarmFieldCount(_local_4);
            if (_local_5 < FAME_COUNT)
            {
                this._openFlag.x = (this._fields[_local_5].x + 40);
                this._openFlag.y = (this._fields[_local_5].y - 27);
                this._openFlag.level = ServerConfigManager.instance.getFarmOpenLevel(_local_4);
                this._openFlag.visible = true;
            }
            else
            {
                this._openFlag.visible = false;
            };
        }

        private function upFlagPlace():void
        {
            var _local_2:DictionaryData;
            var _local_3:int;
            var _local_1:Array = [3, 4, 5, 6, 7, 8];
            if (FarmModelController.instance.model.currentFarmerId == PlayerManager.Instance.Self.ID)
            {
                _local_2 = FarmModelController.instance.model.fieldsInfo;
                _local_3 = 0;
                while (_local_3 < _local_2.length)
                {
                    if (((_local_2[_local_3].fieldID >= 3) && ((_local_2[_local_3].isDig) || (!(_local_2[_local_3].seedID == 0)))))
                    {
                        _local_1.splice(_local_1.indexOf(_local_2[_local_3].fieldID), 1);
                    };
                    _local_3++;
                };
            };
        }

        public function dispose():void
        {
            this.remvoeEvent();
            var _local_1:int;
            while (_local_1 < FAME_COUNT)
            {
                if (this._fields[_local_1])
                {
                    ObjectUtils.disposeObject(this._fields[_local_1]);
                    this._fields[_local_1] = null;
                };
                _local_1++;
            };
            if (this._plantSpeedButton)
            {
                ObjectUtils.disposeObject(this._plantSpeedButton);
            };
            this._plantSpeedButton = null;
            if (this._plantDeleteButton)
            {
                ObjectUtils.disposeObject(this._plantDeleteButton);
            };
            this._plantDeleteButton = null;
            ObjectUtils.disposeObject(this._openFlag);
            this._openFlag = null;
            this._fields = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package farm.view

