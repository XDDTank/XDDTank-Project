// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//bead.view.BeadGetBeadFrame

package bead.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import bagAndInfo.info.MoneyInfoView;
    import flash.display.Bitmap;
    import com.pickgliss.ui.image.Image;
    import com.pickgliss.ui.controls.SimpleBitmapButton;
    import flash.display.MovieClip;
    import com.pickgliss.ui.controls.TextButton;
    import com.pickgliss.ui.text.FilterFrameText;
    import bead.BeadManager;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.data.goods.Price;
    import ddt.utils.PositionUtils;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.PlayerManager;
    import ddt.data.BuffInfo;
    import ddt.events.PlayerPropertyEvent;
    import com.pickgliss.utils.ClassUtils;
    import flash.events.MouseEvent;
    import ddt.manager.SocketManager;
    import ddt.events.CrazyTankSocketEvent;
    import ddt.manager.SoundManager;
    import store.HelpPrompt;
    import store.HelpFrame;
    import com.pickgliss.ui.LayerManager;
    import road7th.comm.PackageIn;
    import baglocked.BaglockedManager;
    import ddt.manager.SavePointManager;
    import trainer.view.NewHandContainer;
    import trainer.data.ArrowType;
    import com.pickgliss.utils.ObjectUtils;

    public class BeadGetBeadFrame extends Sprite implements Disposeable 
    {

        private var _bg:Scale9CornerImage;
        private var _ddtmoneyView:MoneyInfoView;
        private var _myScorePic:Bitmap;
        private var _arrow1:Image;
        private var _arrow2:Image;
        private var _arrow3:Image;
        private var _requestBtn1:SimpleBitmapButton;
        private var _requestBtn2:SimpleBitmapButton;
        private var _requestBtn3:SimpleBitmapButton;
        private var _requestBtn4:SimpleBitmapButton;
        private var _helpBtn:SimpleBitmapButton;
        private var _requestBtnCartoon:MovieClip;
        private var _moneyList:Array;
        private var _myScoreExchangeBtn:TextButton;
        private var _myScoreTxt:FilterFrameText;
        private var _beadMasterText:FilterFrameText;
        private var _isBuyOneKey:Boolean;

        public function BeadGetBeadFrame()
        {
            this._moneyList = BeadManager.instance.beadConfig.GemGold.split("|");
            this.initView();
            this.initEvent();
            this.refreshRequestBtn();
        }

        public function set isBuyOneKey(_arg_1:Boolean):void
        {
            this._isBuyOneKey = _arg_1;
        }

        private function initView():void
        {
            this._arrow1 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.arrowIcon1");
            this._arrow2 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.arrowIcon2");
            this._arrow3 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.arrowIcon3");
            this._bg = ComponentFactory.Instance.creatComponentByStylename("asset.beadGetBeadFrame.BgI");
            this._requestBtn1 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn1");
            this._requestBtn1.tipData = 1;
            this._requestBtn2 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn2");
            this._requestBtn2.tipData = 2;
            this._requestBtn3 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn3");
            this._requestBtn3.tipData = 3;
            this._requestBtn4 = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.requestBtn4");
            this._requestBtn4.tipData = 4;
            this._helpBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.helpBtn");
            this._myScoreExchangeBtn = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.myScoreExchangeBtn");
            this._myScoreExchangeBtn.text = LanguageMgr.GetTranslation("beadSystem.bead.scoreShop");
            this._myScoreTxt = ComponentFactory.Instance.creatComponentByStylename("beadSystem.getBead.myScoreTxt");
            this._myScorePic = ComponentFactory.Instance.creatBitmap("asset.beadSystem.myScorePic");
            this._ddtmoneyView = new MoneyInfoView(Price.GOLD);
            PositionUtils.setPos(this._ddtmoneyView, "bead.ico.goldTxtPos");
            this._beadMasterText = ComponentFactory.Instance.creatComponentByStylename("beadSystem.beadMasterText");
            this._beadMasterText.text = LanguageMgr.GetTranslation("beadSystem.bead.getBeadFrame.beadMaserText");
            addChild(this._bg);
            addChild(this._arrow1);
            addChild(this._arrow2);
            addChild(this._arrow3);
            addChild(this._requestBtn1);
            addChild(this._requestBtn2);
            addChild(this._requestBtn3);
            addChild(this._requestBtn4);
            addChild(this._helpBtn);
            addChild(this._myScorePic);
            addChild(this._myScoreExchangeBtn);
            addChild(this._myScoreTxt);
            addChild(this._ddtmoneyView);
            addChild(this._beadMasterText);
            this.createBtnCartoon();
            this.refreshMoney(null);
        }

        private function refreshMoney(_arg_1:PlayerPropertyEvent):void
        {
            if (((this._isBuyOneKey) && (_arg_1.changedProperties[PlayerInfo.MONEY])))
            {
                this._isBuyOneKey = false;
            };
            this._ddtmoneyView.setInfo(PlayerManager.Instance.Self);
            this._myScoreTxt.text = PlayerManager.Instance.Self.beadScore.toString();
            var _local_2:BuffInfo = PlayerManager.Instance.Self.buffInfo[BuffInfo.GemMaster];
            this._beadMasterText.visible = ((_local_2) && (_local_2.Value > 0));
        }

        private function createBtnCartoon():void
        {
            this._requestBtnCartoon = ClassUtils.CreatInstance("asset.beadSystem.requestBtn.cartoon");
            this._requestBtnCartoon.gotoAndStop(1);
            this._requestBtnCartoon.mouseEnabled = false;
            this._requestBtnCartoon.mouseChildren = false;
            addChild(this._requestBtnCartoon);
        }

        private function initEvent():void
        {
            this._requestBtn1.addEventListener(MouseEvent.CLICK, this.requestBead, false, 0, true);
            this._requestBtn2.addEventListener(MouseEvent.CLICK, this.requestBead, false, 0, true);
            this._requestBtn3.addEventListener(MouseEvent.CLICK, this.requestBead, false, 0, true);
            this._requestBtn4.addEventListener(MouseEvent.CLICK, this.requestBead, false, 0, true);
            SocketManager.Instance.addEventListener(CrazyTankSocketEvent.BEAD_RLIGHT_STATE, this.requestBeadHandler, false, 0, true);
            PlayerManager.Instance.Self.addEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.refreshMoney, false, 0, true);
            this._helpBtn.addEventListener(MouseEvent.CLICK, this.openHelpView, false, 0, true);
            this._myScoreExchangeBtn.addEventListener(MouseEvent.CLICK, this.openScoreShopFrame, false, 0, true);
        }

        private function openScoreShopFrame(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            var _local_2:BeadScoreShopFrame = ComponentFactory.Instance.creatCustomObject("beadSystem.beadScoreShopFrame");
            _local_2.show();
        }

        private function soundPlay(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
        }

        private function openHelpView(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            _arg_1.stopImmediatePropagation();
            var _local_2:HelpPrompt = ComponentFactory.Instance.creat("beadSystem.ComposeHelpPrompt");
            var _local_3:HelpFrame = ComponentFactory.Instance.creat("ddtstore.HelpFrame");
            _local_3.setView(_local_2);
            _local_3.titleText = LanguageMgr.GetTranslation("beadSystem.bead.help.title");
            LayerManager.Instance.addToLayer(_local_3, LayerManager.STAGE_DYANMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function requestBeadHandler(_arg_1:CrazyTankSocketEvent):void
        {
            var _local_2:PackageIn = (_arg_1.pkg as PackageIn);
            PlayerManager.Instance.Self.beadGetStatus = _local_2.readInt();
            this.refreshRequestBtn();
        }

        private function requestBead(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this.doRequestBead(_arg_1);
        }

        public function getlightRequestBeadMoney():int
        {
            var _local_1:int = PlayerManager.Instance.Self.beadGetStatus;
            var _local_2:int = -1;
            if ((_local_1 & 0x08))
            {
                _local_2 = 3;
            }
            else
            {
                if ((_local_1 & 0x04))
                {
                    _local_2 = 2;
                }
                else
                {
                    if ((_local_1 & 0x02))
                    {
                        _local_2 = 1;
                    }
                    else
                    {
                        _local_2 = 0;
                    };
                };
            };
            return (this._moneyList[_local_2]);
        }

        private function doRequestBead(_arg_1:MouseEvent):void
        {
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            var _local_2:Object = _arg_1.currentTarget;
            var _local_3:int = 1;
            var _local_4:int;
            switch (_local_2)
            {
                case this._requestBtn1:
                    _local_3 = 1;
                    _local_4 = this._moneyList[0];
                    break;
                case this._requestBtn2:
                    _local_3 = 2;
                    _local_4 = this._moneyList[1];
                    break;
                case this._requestBtn3:
                    _local_3 = 3;
                    _local_4 = this._moneyList[2];
                    break;
                case this._requestBtn4:
                    _local_3 = 4;
                    _local_4 = this._moneyList[3];
                    break;
                default:
                    _local_3 = 1;
                    _local_4 = this._moneyList[0];
            };
            if (PlayerManager.Instance.Self.Gold < _local_4)
            {
                BeadManager.instance.buyGoldFrame();
                return;
            };
            if (SavePointManager.Instance.isInSavePoint(71))
            {
                if (BeadManager.instance.guildeStepI)
                {
                    NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAD, 0, "trainer.beadClick5", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                }
                else
                {
                    NewHandContainer.Instance.showArrow(ArrowType.CLICK_BEAD, 90, "trainer.beadClick2", "", "", LayerManager.Instance.getLayerByType(LayerManager.GAME_TOP_LAYER));
                };
            };
            SocketManager.Instance.out.sendBeadRequestBead(_local_3, false, 2);
        }

        private function refreshRequestBtn():void
        {
            var _local_1:int = PlayerManager.Instance.Self.beadGetStatus;
            if ((_local_1 & 0x01))
            {
                this._requestBtn1.enable = true;
                this._requestBtnCartoon.x = 434;
                this._requestBtnCartoon.y = 268;
            }
            else
            {
                this._requestBtn1.enable = false;
            };
            if ((_local_1 & 0x02))
            {
                this._requestBtn2.enable = true;
                this._requestBtnCartoon.x = 532;
                this._requestBtnCartoon.y = 268;
            }
            else
            {
                this._requestBtn2.enable = false;
            };
            if ((_local_1 & 0x04))
            {
                this._requestBtn3.enable = true;
                this._requestBtnCartoon.x = 639;
                this._requestBtnCartoon.y = 271;
            }
            else
            {
                this._requestBtn3.enable = false;
            };
            if ((_local_1 & 0x08))
            {
                this._requestBtn4.enable = true;
                this._requestBtnCartoon.x = 740;
                this._requestBtnCartoon.y = 270;
            }
            else
            {
                this._requestBtn4.enable = false;
            };
        }

        public function show():void
        {
            LayerManager.Instance.addToLayer(this, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.BLCAK_BLOCKGOUND);
        }

        private function removeEvent():void
        {
            this._requestBtn1.removeEventListener(MouseEvent.CLICK, this.requestBead);
            this._requestBtn2.removeEventListener(MouseEvent.CLICK, this.requestBead);
            this._requestBtn3.removeEventListener(MouseEvent.CLICK, this.requestBead);
            this._requestBtn4.removeEventListener(MouseEvent.CLICK, this.requestBead);
            SocketManager.Instance.removeEventListener(CrazyTankSocketEvent.BEAD_RLIGHT_STATE, this.requestBeadHandler);
            PlayerManager.Instance.Self.removeEventListener(PlayerPropertyEvent.PROPERTY_CHANGE, this.refreshMoney);
            this._helpBtn.removeEventListener(MouseEvent.CLICK, this.openHelpView);
            this._myScoreExchangeBtn.removeEventListener(MouseEvent.CLICK, this.openScoreShopFrame);
        }

        private function disposeCartoon():void
        {
            if (this._requestBtnCartoon)
            {
                this._requestBtnCartoon.gotoAndStop(this._requestBtnCartoon.totalFrames);
                ObjectUtils.disposeObject(this._requestBtnCartoon);
                this._requestBtnCartoon = null;
            };
        }

        public function dispose():void
        {
            this.removeEvent();
            this.disposeCartoon();
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            if (this._arrow1)
            {
                ObjectUtils.disposeObject(this._arrow1);
            };
            this._arrow1 = null;
            if (this._arrow2)
            {
                ObjectUtils.disposeObject(this._arrow2);
            };
            this._arrow2 = null;
            if (this._arrow3)
            {
                ObjectUtils.disposeObject(this._arrow3);
            };
            this._arrow3 = null;
            if (this._myScorePic)
            {
                ObjectUtils.disposeObject(this._myScorePic);
            };
            this._myScorePic = null;
            if (this._requestBtn1)
            {
                ObjectUtils.disposeObject(this._requestBtn1);
            };
            this._requestBtn1 = null;
            if (this._requestBtn2)
            {
                ObjectUtils.disposeObject(this._requestBtn2);
            };
            this._requestBtn2 = null;
            if (this._requestBtn3)
            {
                ObjectUtils.disposeObject(this._requestBtn3);
            };
            this._requestBtn3 = null;
            if (this._requestBtn4)
            {
                ObjectUtils.disposeObject(this._requestBtn4);
            };
            this._requestBtn4 = null;
            if (this._helpBtn)
            {
                ObjectUtils.disposeObject(this._helpBtn);
            };
            this._helpBtn = null;
            if (this._myScoreExchangeBtn)
            {
                ObjectUtils.disposeObject(this._myScoreExchangeBtn);
            };
            this._myScoreExchangeBtn = null;
            if (this._myScoreTxt)
            {
                ObjectUtils.disposeObject(this._myScoreTxt);
            };
            this._myScoreTxt = null;
            ObjectUtils.disposeObject(this._beadMasterText);
            this._beadMasterText = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package bead.view

