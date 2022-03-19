// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//game.view.card.LuckyCard

package game.view.card
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.MovieClip;
    import game.model.Player;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.text.GradientText;
    import bagAndInfo.cell.BagCell;
    import flash.display.Bitmap;
    import flash.geom.Point;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import platformapi.tencent.DiamondManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import com.greensock.TweenLite;
    import com.greensock.easing.Quint;
    import ddt.manager.SoundManager;
    import game.GameManager;
    import ddt.manager.GameInSocketOut;
    import room.RoomManager;
    import room.model.RoomInfo;
    import ddt.manager.MessageTipManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.AlertManager;
    import com.pickgliss.ui.LayerManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.PlayerManager;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.utils.ObjectUtils;
    import flash.text.TextFormat;
    import ddt.data.goods.ItemTemplateInfo;
    import vip.VipController;
    import ddt.manager.ItemManager;
    import ddt.manager.ChatManager;

    public class LuckyCard extends Sprite implements Disposeable 
    {

        public static const AFTER_GAME_CARD:int = 0;
        public static const WITHIN_GAME_CARD:int = 1;

        public var allowClick:Boolean;
        public var msg:String;
        public var isPayed:Boolean;
        private var _idx:int;
        private var _cardType:int;
        private var _luckyCardMc:MovieClip;
        private var _info:Player;
        private var _templateID:int;
        private var _count:int;
        private var _isVip:Boolean;
        private var _nickName:FilterFrameText;
        private var _itemName:FilterFrameText;
        private var _vipNameTxt:GradientText;
        private var _itemCell:BagCell;
        private var _itemGoldTxt:Bitmap;
        private var _itemBitmap:Bitmap;
        private var _goldTxt:FilterFrameText;
        private var _overShape:Bitmap;
        private var _overEffectPoint:Point;
        private var _payAlert:BaseAlerFrame;

        public function LuckyCard(_arg_1:int, _arg_2:int)
        {
            this._idx = _arg_1;
            this._cardType = _arg_2;
            this.init();
        }

        private function get TAKE_CARD_FEE():int
        {
            if (DiamondManager.instance.isInTencent)
            {
                return (60);
            };
            return (50);
        }

        private function init():void
        {
            buttonMode = true;
            this._overShape = ComponentFactory.Instance.creatBitmap("takeoutCard.LuckyCardOverFilter");
            this._overShape.x = -12;
            this._overShape.y = -12;
            this._luckyCardMc = ComponentFactory.Instance.creat("asset.takeoutCard.LuckyCard");
            this._luckyCardMc.addEventListener(Event.ENTER_FRAME, this.__checkMovie);
            addChild(this._luckyCardMc);
        }

        private function __checkMovie(_arg_1:Event):void
        {
            if (this._luckyCardMc.numChildren == 5)
            {
                if (this._luckyCardMc.cardMc.totalFrames == 5)
                {
                    this._luckyCardMc.removeEventListener(Event.ENTER_FRAME, this.__checkMovie);
                    this._luckyCardMc.cardMc.addFrameScript((this._luckyCardMc.cardMc.totalFrames - 1), this.showResult);
                };
            };
        }

        public function set enabled(_arg_1:Boolean):void
        {
            buttonMode = _arg_1;
            if (_arg_1)
            {
                this._overEffectPoint = new Point(y, (y - 14));
                addEventListener(MouseEvent.CLICK, this.__onClick);
                addEventListener(MouseEvent.ROLL_OVER, this.__onRollOver);
                addEventListener(MouseEvent.ROLL_OUT, this.__onRollOut);
            }
            else
            {
                removeEventListener(MouseEvent.CLICK, this.__onClick);
                removeEventListener(MouseEvent.ROLL_OVER, this.__onRollOver);
                removeEventListener(MouseEvent.ROLL_OUT, this.__onRollOut);
                this.__onRollOut();
            };
        }

        private function __onRollOver(_arg_1:MouseEvent=null):void
        {
            if ((!(this._overEffectPoint)))
            {
                return;
            };
            addChild(this._overShape);
            TweenLite.killTweensOf(this);
            TweenLite.to(this, 0.3, {
                "y":this._overEffectPoint.y,
                "ease":Quint.easeOut
            });
        }

        private function __onRollOut(_arg_1:MouseEvent=null):void
        {
            if ((!(this._overEffectPoint)))
            {
                return;
            };
            if (contains(this._overShape))
            {
                removeChild(this._overShape);
            };
            TweenLite.killTweensOf(this);
            TweenLite.to(this, 0.3, {
                "y":this._overEffectPoint.x,
                "ease":Quint.easeOut
            });
        }

        protected function __onClick(_arg_1:MouseEvent):void
        {
            if (this.allowClick)
            {
                SoundManager.instance.play("008");
                if (this.isPayed)
                {
                    if (GameManager.Instance.Current.selfGamePlayer.hasGardGet)
                    {
                        GameInSocketOut.sendPaymentTakeCard(this._idx);
                        GameManager.Instance.Current.selfGamePlayer.hasGardGet = false;
                        this.enabled = false;
                    }
                    else
                    {
                        this.payAlert();
                    };
                }
                else
                {
                    if (RoomManager.Instance.current.type == RoomInfo.FRESHMAN_ROOM)
                    {
                        GameInSocketOut.sendBossTakeOut(this._idx);
                    }
                    else
                    {
                        if (this._cardType == WITHIN_GAME_CARD)
                        {
                            GameInSocketOut.sendBossTakeOut(this._idx);
                        }
                        else
                        {
                            GameInSocketOut.sendGameTakeOut(this._idx);
                        };
                    };
                    this.enabled = false;
                };
            }
            else
            {
                MessageTipManager.getInstance().show(this.msg);
            };
        }

        private function payAlert():void
        {
            var _local_1:String;
            _local_1 = LanguageMgr.GetTranslation("tank.gameover.payConfirm.contentCommonNoDiscount", this.TAKE_CARD_FEE);
            this._payAlert = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.gameover.payConfirm.title"), _local_1, LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), false, false, false, LayerManager.ALPHA_BLOCKGOUND);
            if (this._payAlert.parent)
            {
                this._payAlert.parent.removeChild(this._payAlert);
            };
            LayerManager.Instance.addToLayer(this._payAlert, LayerManager.GAME_DYNAMIC_LAYER, true, LayerManager.ALPHA_BLOCKGOUND);
            this._payAlert.addEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            this.__onRollOut();
        }

        private function onFrameResponse(_arg_1:FrameEvent):void
        {
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                if (PlayerManager.Instance.Self.totalMoney < this.TAKE_CARD_FEE)
                {
                    LeavePageManager.showFillFrame();
                    return;
                };
                GameInSocketOut.sendPaymentTakeCard(this._idx);
                this.enabled = false;
            };
            this._payAlert.removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            ObjectUtils.disposeObject(this._payAlert);
            this._payAlert = null;
        }

        public function play(_arg_1:Player, _arg_2:int, _arg_3:int, _arg_4:Boolean):void
        {
            this._info = _arg_1;
            this._templateID = _arg_2;
            this._count = _arg_3;
            this._isVip = _arg_4;
            if (((!(_arg_1)) || (!(this._info.isSelf))))
            {
                this._luckyCardMc.lightFrame.visible = false;
                this._luckyCardMc.vipLightFrame.visible = false;
                this._luckyCardMc.starMc.visible = false;
            };
            SoundManager.instance.play("048");
            this.openNormalCard();
            this.enabled = false;
        }

        private function openNormalCard():void
        {
            this._luckyCardMc["lightFrame"].gotoAndPlay(2);
            this._luckyCardMc["cardMc"].gotoAndPlay(2);
            this._luckyCardMc["vipLightFrame"].gotoAndStop(1);
            this._luckyCardMc["vipCardMc"].gotoAndStop(1);
            this._luckyCardMc["starMc"].gotoAndPlay(2);
        }

        private function openVipCard():void
        {
            this._luckyCardMc["lightFrame"].gotoAndStop(1);
            this._luckyCardMc["cardMc"].gotoAndPlay(2);
            this._luckyCardMc["vipLightFrame"].gotoAndPlay(2);
            this._luckyCardMc["vipCardMc"].gotoAndPlay(2);
            this._luckyCardMc["starMc"].gotoAndPlay(2);
        }

        private function showResult():void
        {
            var textFormat:TextFormat;
            var tempInfo:ItemTemplateInfo;
            try
            {
                this._luckyCardMc["cardMc"].stop();
            }
            catch(e:Error)
            {
            }
            finally
            {
                if (this._info)
                {
                    this._nickName = ComponentFactory.Instance.creatComponentByStylename("takeoutCard.PlayerItemNameTxt");
                    this._nickName.text = ((this._info.playerInfo) ? this._info.playerInfo.NickName : "");
                    if (((this._info.playerInfo) && (this._info.playerInfo.IsVIP)))
                    {
                        this._vipNameTxt = VipController.instance.getVipNameTxt(90, this._info.playerInfo.VIPtype);
                        this._vipNameTxt.x = this._nickName.x;
                        this._vipNameTxt.y = (this._nickName.y + 1);
                        textFormat = new TextFormat();
                        textFormat.align = "center";
                        textFormat.bold = true;
                        this._vipNameTxt.textField.defaultTextFormat = textFormat;
                        this._vipNameTxt.text = this._nickName.text;
                        addChild(this._vipNameTxt);
                    }
                    else
                    {
                        addChild(this._nickName);
                    };
                };
                if (this._templateID > 0)
                {
                    this._itemCell = new BagCell(0);
                    this._itemCell.BGVisible = false;
                    this._itemName = ComponentFactory.Instance.creatComponentByStylename("takeoutCard.CardItemNameTxt");
                    tempInfo = ItemManager.Instance.getTemplateById(this._templateID);
                    if (((tempInfo) && (this._itemCell)))
                    {
                        this._itemCell.info = tempInfo;
                        this._itemName.text = tempInfo.Name;
                        this._itemCell.x = 32;
                        this._itemCell.y = 57;
                        this._itemCell.mouseEnabled = (this._itemCell.mouseChildren = false);
                        if (this._itemName.numLines > 1)
                        {
                            this._itemName.y = (this._itemName.y - 9);
                        };
                        addChild(this._itemCell);
                        addChild(this._itemName);
                    };
                }
                else
                {
                    if (this._templateID == -100)
                    {
                        this._itemGoldTxt = ComponentFactory.Instance.creatBitmap("asset.takeoutCard.GoldTxt");
                        this._itemBitmap = ComponentFactory.Instance.creatBitmap("asset.takeoutCard.GoldBitmap");
                        this._goldTxt = ComponentFactory.Instance.creatComponentByStylename("takeoutCard.GoldTxt");
                        this._goldTxt.text = this._count.toString();
                        addChild(this._itemGoldTxt);
                        addChild(this._itemBitmap);
                        addChild(this._goldTxt);
                        if (((this._info) && (this._info.isSelf)))
                        {
                            ChatManager.Instance.sysChatYellow(LanguageMgr.GetTranslation("tank.gameover.takecard.getgold", this._count));
                        };
                    }
                    else
                    {
                        if (this._templateID != -200)
                        {
                            if (this._templateID == -300)
                            {
                            };
                        };
                    };
                };
            };
        }

        public function dispose():void
        {
            if (this._payAlert)
            {
                this._payAlert.removeEventListener(FrameEvent.RESPONSE, this.onFrameResponse);
            };
            removeEventListener(MouseEvent.CLICK, this.__onClick);
            removeEventListener(MouseEvent.ROLL_OVER, this.__onRollOver);
            removeEventListener(MouseEvent.ROLL_OUT, this.__onRollOut);
            ObjectUtils.disposeObject(this._luckyCardMc);
            this._luckyCardMc = null;
            ObjectUtils.disposeObject(this._nickName);
            this._nickName = null;
            ObjectUtils.disposeObject(this._itemName);
            this._itemName = null;
            ObjectUtils.disposeObject(this._vipNameTxt);
            this._vipNameTxt = null;
            ObjectUtils.disposeObject(this._itemCell);
            this._itemCell = null;
            ObjectUtils.disposeObject(this._itemGoldTxt);
            this._itemGoldTxt = null;
            ObjectUtils.disposeObject(this._itemBitmap);
            this._itemBitmap = null;
            ObjectUtils.disposeObject(this._goldTxt);
            this._goldTxt = null;
            ObjectUtils.disposeObject(this._payAlert);
            this._payAlert = null;
            if (((this._overShape) && (this._overShape.parent)))
            {
                this._overShape.parent.removeChild(this._overShape);
            };
            this._overShape = null;
            this._overEffectPoint = null;
            this._info = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package game.view.card

