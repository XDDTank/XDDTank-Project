// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//changeColor.view.ChangeColorRightView

package changeColor.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import com.pickgliss.ui.image.MovieImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.effect.IEffect;
    import com.pickgliss.ui.controls.BaseButton;
    import changeColor.ChangeColorModel;
    import flash.events.Event;
    import changeColor.ChangeColorCellEvent;
    import flash.events.MouseEvent;
    import com.pickgliss.utils.ObjectUtils;
    import com.pickgliss.effect.EffectManager;
    import com.pickgliss.events.FrameEvent;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import ddt.manager.ShopManager;
    import ddt.data.EquipType;
    import ddt.manager.LeavePageManager;
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import baglocked.BaglockedManager;
    import com.pickgliss.ui.AlertManager;
    import ddt.manager.LanguageMgr;
    import com.pickgliss.ui.LayerManager;
    import flash.geom.Rectangle;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.effect.EffectTypes;
    import ddt.data.BagInfo;
    import ddt.manager.SocketManager;

    public class ChangeColorRightView extends Sprite implements Disposeable 
    {

        private var _bag:ColorChangeBagListView;
        private var _bg1:Scale9CornerImage;
        private var _btnBg:Scale9CornerImage;
        private var _text1Img:MovieImage;
        private var _textImg:FilterFrameText;
        private var _shineEffect:IEffect;
        private var _changeColorBtn:BaseButton;
        private var _model:ChangeColorModel;

        public function ChangeColorRightView()
        {
            addEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
            this.init();
        }

        public function dispose():void
        {
            this._model.removeEventListener(ChangeColorCellEvent.SETCOLOR, this.__updateBtn);
            this._changeColorBtn.removeEventListener(MouseEvent.CLICK, this.__changeColor);
            ObjectUtils.disposeAllChildren(this);
            this._changeColorBtn = null;
            this._bag = null;
            this._model = null;
            EffectManager.Instance.removeEffect(this._shineEffect);
            this._shineEffect = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }

        public function set model(_arg_1:ChangeColorModel):void
        {
            this._model = _arg_1;
            this.dataUpdate();
        }

        private function __alertChangeColor(_arg_1:FrameEvent):void
        {
            _arg_1.currentTarget.removeEventListener(FrameEvent.RESPONSE, this.__alertChangeColor);
            SoundManager.instance.play("008");
            if (((_arg_1.responseCode == FrameEvent.SUBMIT_CLICK) || (_arg_1.responseCode == FrameEvent.ENTER_CLICK)))
            {
                if (PlayerManager.Instance.Self.totalMoney < ShopManager.Instance.getGoodsByTemplateID(EquipType.COLORCARD).getItemPrice(1).moneyValue)
                {
                    LeavePageManager.showFillFrame();
                    return;
                };
                this.sendChangeColor();
            };
        }

        private function __changeColor(_arg_1:MouseEvent):void
        {
            var _local_2:BaseAlerFrame;
            SoundManager.instance.play("008");
            if (PlayerManager.Instance.Self.bagLocked)
            {
                BaglockedManager.Instance.show();
                return;
            };
            if (this._model.place != -1)
            {
                this.sendChangeColor();
                this._model.place = -1;
            }
            else
            {
                if (this.hasColorCard() != -1)
                {
                    this._model.place = this.hasColorCard();
                    this.sendChangeColor();
                    this._model.place = -1;
                }
                else
                {
                    _local_2 = AlertManager.Instance.simpleAlert(LanguageMgr.GetTranslation("tank.consortia.myconsortia.frame.MyConsortiaTax.info"), LanguageMgr.GetTranslation("tank.view.changeColor.lackCard", ShopManager.Instance.getGoodsByTemplateID(EquipType.COLORCARD).getItemPrice(1).moneyValue), LanguageMgr.GetTranslation("ok"), LanguageMgr.GetTranslation("cancel"), true, false, false, LayerManager.ALPHA_BLOCKGOUND);
                    _local_2.addEventListener(FrameEvent.RESPONSE, this.__alertChangeColor);
                };
            };
            this._changeColorBtn.enable = false;
        }

        private function __updateBtn(_arg_1:Event):void
        {
            if ((!(this._model.changed)))
            {
                this._changeColorBtn.enable = false;
            }
            else
            {
                this._changeColorBtn.enable = true;
            };
        }

        private function dataUpdate():void
        {
            this._model.addEventListener(ChangeColorCellEvent.SETCOLOR, this.__updateBtn);
            this._bag.setData(this._model.colorEditableBag);
        }

        private function hasColorCard():int
        {
            if (PlayerManager.Instance.Self.Bag.getItemCountByTemplateId(EquipType.COLORCARD) > 0)
            {
                return (PlayerManager.Instance.Self.Bag.findFistItemByTemplateId(EquipType.COLORCARD).Place);
            };
            return (-1);
        }

        private function init():void
        {
            var _local_1:Rectangle;
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.rightViewBgRec");
            this._bg1 = ComponentFactory.Instance.creatComponentByStylename("ColorBGAsset4");
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.rightViewBgRec1");
            ObjectUtils.copyPropertyByRectangle(this._bg1, _local_1);
            addChild(this._bg1);
            this._text1Img = ComponentFactory.Instance.creatComponentByStylename("asset.changeColor.label");
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.text1ImgRec");
            ObjectUtils.copyPropertyByRectangle(this._text1Img, _local_1);
            addChild(this._text1Img);
            this._textImg = ComponentFactory.Instance.creatComponentByStylename("asset.changeColor.text2");
            this._textImg.text = LanguageMgr.GetTranslation("tank.view.changeColor.text5");
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.textImgRec");
            ObjectUtils.copyPropertyByRectangle(this._textImg, _local_1);
            addChild(this._textImg);
            this._bag = new ColorChangeBagListView();
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.bagListViewRec");
            ObjectUtils.copyPropertyByRectangle(this._bag, _local_1);
            addChild(this._bag);
            this._btnBg = ComponentFactory.Instance.creatComponentByStylename("changeColor.changeColorBtn.bg");
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.buttonBgRec");
            ObjectUtils.copyPropertyByRectangle(this._btnBg, _local_1);
            addChild(this._btnBg);
            this._changeColorBtn = ComponentFactory.Instance.creatComponentByStylename("changeColor.changeColorBtn");
            _local_1 = ComponentFactory.Instance.creatCustomObject("changeColor.changeColorBtnRec");
            ObjectUtils.copyPropertyByRectangle(this._changeColorBtn, _local_1);
            this._changeColorBtn.enable = false;
            addChild(this._changeColorBtn);
            this._changeColorBtn.addEventListener(MouseEvent.CLICK, this.__changeColor);
        }

        private function __addToStage(_arg_1:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, this.__addToStage);
            var _local_2:Rectangle = ComponentFactory.Instance.creatCustomObject("changeColor.textImgGlowRec");
            this._shineEffect = EffectManager.Instance.creatEffect(EffectTypes.ADD_MOVIE_EFFECT, this, "asset.changeColor.shine", _local_2);
            this._shineEffect.stop();
        }

        private function sendChangeColor():void
        {
            var _local_1:int;
            var _local_2:int;
            _local_1 = BagInfo.EQUIPBAG;
            _local_2 = this._model.place;
            var _local_3:int = this._model.currentItem.BagType;
            var _local_4:int = this._model.currentItem.Place;
            var _local_5:String = this._model.currentItem.Color;
            var _local_6:String = this._model.currentItem.Skin;
            var _local_7:int = EquipType.COLORCARD;
            this._model.initColor = _local_5;
            this._model.initSkinColor = _local_6;
            SocketManager.Instance.out.sendChangeColor(_local_1, _local_2, _local_3, _local_4, _local_5, _local_6, _local_7);
            this._model.savaItemInfo();
        }


    }
}//package changeColor.view

