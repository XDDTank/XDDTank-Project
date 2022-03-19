// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tryonSystem.TryonPanelView

package tryonSystem
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.MovieImage;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.controls.SelectedCheckButton;
    import road7th.data.DictionaryData;
    import ddt.view.character.RoomCharacter;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import flash.display.MovieClip;
    import ddt.data.goods.InventoryItemInfo;
    import equipretrieve.effect.GlowFilterAnimation;
    import bagAndInfo.cell.PersonalInfoCell;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.manager.LanguageMgr;
    import ddt.view.character.CharactoryFactory;
    import ddt.utils.PositionUtils;
    import equipretrieve.effect.AnimationControl;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import ddt.manager.PlayerManager;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;

    public class TryonPanelView extends Sprite implements Disposeable 
    {

        private static const CELL_PLACE:Array = [0, 1, 2, 3, 4, 5, 11, 13];

        private var _controller:TryonSystemController;
        private var _model:TryonModel;
        private var _bg:MovieImage;
        private var _bg1:ScaleBitmapImage;
        private var _tryTxt:FilterFrameText;
        private var _hideTxt:FilterFrameText;
        private var _hideHatBtn:SelectedCheckButton;
        private var _hideGlassBtn:SelectedCheckButton;
        private var _hideSuitBtn:SelectedCheckButton;
        private var _hideWingBtn:SelectedCheckButton;
        private var _bagItems:DictionaryData;
        private var _character:RoomCharacter;
        private var _itemList:SimpleTileList;
        private var _cells:Array;
        private var _bagCells:Array;
        private var _nickName:FilterFrameText;
        private var _effect:MovieClip;

        public function TryonPanelView(_arg_1:TryonSystemController)
        {
            this._controller = _arg_1;
            this._model = this._controller.model;
            this._cells = [];
            this.initView();
            this.initEvents();
        }

        private function initView():void
        {
            var _local_2:InventoryItemInfo;
            var _local_3:int;
            var _local_4:Sprite;
            var _local_5:TryonCell;
            var _local_6:MovieImage;
            var _local_7:GlowFilterAnimation;
            var _local_8:PersonalInfoCell;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("core.tryOnBigBg");
            addChild(this._bg);
            this._bg1 = ComponentFactory.Instance.creatComponentByStylename("core.tryOnSmallBg");
            addChild(this._bg1);
            this._tryTxt = ComponentFactory.Instance.creatComponentByStylename("asset.tryOnTxt");
            addChild(this._tryTxt);
            this._tryTxt.text = LanguageMgr.GetTranslation("ddt.quest.tryon.tryonTxt");
            this._hideTxt = ComponentFactory.Instance.creatComponentByStylename("asset.core.hideTxt");
            addChild(this._hideTxt);
            this._hideTxt.text = LanguageMgr.GetTranslation("ddt.quest.tryon.hide");
            this._hideGlassBtn = ComponentFactory.Instance.creatComponentByStylename("tryon.HideHatCheckBox");
            addChild(this._hideGlassBtn);
            this._hideHatBtn = ComponentFactory.Instance.creatComponentByStylename("tryon.HideGlassCheckBox");
            addChild(this._hideHatBtn);
            this._hideSuitBtn = ComponentFactory.Instance.creatComponentByStylename("tryon.HideSuitCheckBox");
            addChild(this._hideSuitBtn);
            this._hideWingBtn = ComponentFactory.Instance.creatComponentByStylename("tryon.HideWingCheckBox");
            addChild(this._hideWingBtn);
            this._hideHatBtn.text = LanguageMgr.GetTranslation("shop.ShopIITryDressView.hideHat");
            this._hideGlassBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.glass");
            this._hideSuitBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.suit");
            this._hideWingBtn.text = LanguageMgr.GetTranslation("tank.view.changeColor.ChangeColorLeftView.wing");
            this._hideGlassBtn.selected = this._model.playerInfo.getGlassHide();
            this._hideSuitBtn.selected = this._model.playerInfo.getSuitesHide();
            this._hideWingBtn.selected = this._model.playerInfo.wingHide;
            this._character = (CharactoryFactory.createCharacter(this._model.playerInfo, "room") as RoomCharacter);
            PositionUtils.setPos(this._character, "quest.tryon.character.pos");
            addChild(this._character);
            this._character.show(false, -1);
            this._effect = ComponentFactory.Instance.creat("asset.core.tryonEffect");
            PositionUtils.setPos(this._effect, "tryonSystem.TryonPanelView.effectPos");
            this._effect.stop();
            addChild(this._effect);
            this._itemList = new SimpleTileList(2);
            this._itemList.vSpace = 60;
            this._itemList.hSpace = 50;
            PositionUtils.setPos(this._itemList, "quest.tryon.simplelistPos");
            var _local_1:AnimationControl = new AnimationControl();
            _local_1.addEventListener(Event.COMPLETE, this._cellLightComplete);
            for each (_local_2 in this._model.items)
            {
                _local_4 = new Sprite();
                _local_4.graphics.beginFill(0xFFFFFF, 0);
                _local_4.graphics.drawRect(0, 0, 43, 43);
                _local_4.graphics.endFill();
                _local_5 = new TryonCell(_local_4);
                _local_5.info = _local_2;
                _local_5.addEventListener(MouseEvent.CLICK, this.__onClick);
                _local_5.buttonMode = true;
                this._itemList.addChild(_local_5);
                this._cells.push(_local_5);
                if (_local_2.CategoryID == 3)
                {
                    this._hideHatBtn.selected = true;
                    this._model.playerInfo.setHatHide(this._hideHatBtn.selected);
                }
                else
                {
                    this._hideHatBtn.selected = this._model.playerInfo.getHatHide();
                };
                _local_6 = ComponentFactory.Instance.creatComponentByStylename("asset.core.itemBigShinelight");
                _local_6.movie.play();
                _local_5.addChildAt(_local_6, 1);
                _local_7 = new GlowFilterAnimation();
                _local_7.start(_local_6, false, 16763955, 0, 0);
                _local_7.addMovie(0, 0, 19, 0);
                _local_1.addMovies(_local_7);
            };
            addChild(this._itemList);
            this._bagItems = this._model.bagItems;
            this._bagCells = [];
            _local_3 = 0;
            while (_local_3 < 8)
            {
                _local_8 = new PersonalInfoCell(_local_3, (this._bagItems[CELL_PLACE[_local_3]] as InventoryItemInfo), true);
                this._bagCells.push(_local_8);
                _local_3++;
            };
            this._nickName = ComponentFactory.Instance.creatComponentByStylename("tryonNickNameText");
            addChild(this._nickName);
            this._nickName.text = PlayerManager.Instance.Self.NickName;
            _local_1.startMovie();
        }

        private function _cellLightComplete(_arg_1:Event):void
        {
            var _local_2:int;
            var _local_3:int;
            var _local_4:MovieImage;
            _arg_1.currentTarget.removeEventListener(Event.COMPLETE, this._cellLightComplete);
            if (this._cells)
            {
                _local_2 = this._cells.length;
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    _local_4 = this._cells[_local_3].removeChildAt(1);
                    _local_4.dispose();
                    _local_3++;
                };
            };
        }

        private function initEvents():void
        {
            this._hideGlassBtn.addEventListener(MouseEvent.CLICK, this.__hideGlassClickHandler);
            this._hideHatBtn.addEventListener(MouseEvent.CLICK, this.__hideHatClickHandler);
            this._hideSuitBtn.addEventListener(MouseEvent.CLICK, this.__hideSuitClickHandler);
            this._hideWingBtn.addEventListener(MouseEvent.CLICK, this.__hideWingClickHandler);
            this._model.addEventListener(Event.CHANGE, this.__onchange);
        }

        private function removeEvents():void
        {
            this._hideGlassBtn.removeEventListener(MouseEvent.CLICK, this.__hideGlassClickHandler);
            this._hideHatBtn.removeEventListener(MouseEvent.CLICK, this.__hideHatClickHandler);
            this._hideSuitBtn.removeEventListener(MouseEvent.CLICK, this.__hideSuitClickHandler);
            this._hideWingBtn.removeEventListener(MouseEvent.CLICK, this.__hideWingClickHandler);
            this._model.removeEventListener(Event.CHANGE, this.__onchange);
        }

        private function __onchange(_arg_1:Event):void
        {
            var _local_2:int;
            while (_local_2 < 8)
            {
                this._bagCells[_local_2].info = (this._bagItems[CELL_PLACE[_local_2]] as InventoryItemInfo);
                _local_2++;
            };
        }

        private function __hideWingClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._model.playerInfo.wingHide = this._hideWingBtn.selected;
        }

        private function __hideSuitClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._model.playerInfo.setSuiteHide(this._hideSuitBtn.selected);
        }

        private function __hideHatClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._model.playerInfo.setHatHide(this._hideHatBtn.selected);
        }

        private function __hideGlassClickHandler(_arg_1:MouseEvent):void
        {
            SoundManager.instance.play("008");
            this._model.playerInfo.setGlassHide(this._hideGlassBtn.selected);
        }

        private function __onClick(_arg_1:MouseEvent):void
        {
            var _local_2:TryonCell;
            SoundManager.instance.play("008");
            for each (_local_2 in this._cells)
            {
                _local_2.selected = false;
            };
            TryonCell(_arg_1.currentTarget).selected = true;
            this._model.selectedItem = (TryonCell(_arg_1.currentTarget).info as InventoryItemInfo);
            if (this._effect)
            {
                this._effect.play();
            };
        }

        public function dispose():void
        {
            var _local_1:TryonCell;
            var _local_2:PersonalInfoCell;
            this.removeEvents();
            for each (_local_1 in this._cells)
            {
                _local_1.removeEventListener(MouseEvent.CLICK, this.__onClick);
                _local_1.dispose();
            };
            this._cells = null;
            for each (_local_2 in this._bagCells)
            {
                _local_2.dispose();
            };
            this._bagCells = null;
            if (this._effect)
            {
                if (this._effect.parent)
                {
                    this._effect.parent.removeChild(this._effect);
                };
                this._effect = null;
            };
            this._bg1.dispose();
            this._bg1 = null;
            this._bg.dispose();
            this._bg = null;
            ObjectUtils.disposeObject(this._tryTxt);
            this._tryTxt = null;
            ObjectUtils.disposeObject(this._hideTxt);
            this._hideTxt = null;
            ObjectUtils.disposeObject(this._hideGlassBtn);
            this._hideGlassBtn = null;
            ObjectUtils.disposeObject(this._hideSuitBtn);
            this._hideSuitBtn = null;
            ObjectUtils.disposeObject(this._hideWingBtn);
            this._hideWingBtn = null;
            ObjectUtils.disposeObject(this._nickName);
            this._nickName = null;
            this._character.dispose();
            this._character = null;
            this._itemList.dispose();
            this._itemList = null;
            this._bagItems = null;
            this._model = null;
            this._controller = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package tryonSystem

