// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//store.view.Compose.view.ComposeItemsView

package store.view.Compose.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import road7th.data.DictionaryData;
    import com.pickgliss.ui.image.Scale9CornerImage;
    import flash.geom.Point;
    import store.view.Compose.ComposeController;
    import store.view.Compose.ComposeType;
    import com.pickgliss.ui.ComponentFactory;
    import store.view.Compose.ComposeEvents;
    import ddt.manager.SavePointManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ComposeItemsView extends Sprite implements Disposeable 
    {

        private var _bigItemDic:DictionaryData;
        private var _middelItemDic:DictionaryData;
        private var _currentType:int;
        private var _itemArr:Array;
        private var _bg:Scale9CornerImage;
        private var _itemList:Array;
        private var _pos1:Point;

        public function ComposeItemsView()
        {
            this.initData();
            this.initView();
            this.initEvent();
        }

        public function show():void
        {
            this.visible = true;
        }

        private function initData():void
        {
            this._bigItemDic = ComposeController.instance.model.composeBigDic;
            this._middelItemDic = ComposeController.instance.model.composeMiddelDic;
            this._currentType = ComposeType.EQUIP;
            ComposeController.instance.model.resetseletectedPage();
        }

        private function initView():void
        {
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ddtstore.StoreIIComposeBG.composeItemsView.bg");
            addChild(this._bg);
            this._pos1 = ComponentFactory.Instance.creatCustomObject("ddtstore.StoreIIComposeBG.composeItemsView.pos1");
        }

        private function drawItems():void
        {
            var _local_2:ComposeBigItem;
            this._itemArr = new Array();
            var _local_1:int = 1;
            while (_local_1 <= this._bigItemDic.length)
            {
                _local_2 = new ComposeBigItem(_local_1);
                if (_local_1 == this._currentType)
                {
                    _local_2.selected = true;
                };
                _local_2.addEventListener(ComposeEvents.CLICK_BIG_ITEM, this.__bigItemClick);
                addChild(_local_2);
                this._itemArr.push(_local_2);
                if (((SavePointManager.Instance.isInSavePoint(26)) && (!(ComposeController.instance.model.composeSuccess))))
                {
                    if (_local_1 == ComposeType.EQUIP)
                    {
                        _local_2.enable = true;
                    }
                    else
                    {
                        _local_2.enable = false;
                    };
                };
                _local_1++;
            };
            this.setPos();
        }

        private function setPos():void
        {
            if (this._itemArr[0])
            {
                this._itemArr[0].x = this._pos1.x;
                this._itemArr[0].y = -8;
            };
            var _local_1:int = 1;
            while (_local_1 < this._itemArr.length)
            {
                if (this._itemArr[(_local_1 - 1)].height > this._pos1.y)
                {
                    this._itemArr[_local_1].y = ((this._itemArr[(_local_1 - 1)].y + this._pos1.y) + 22);
                }
                else
                {
                    this._itemArr[_local_1].y = ((this._itemArr[(_local_1 - 1)].y + this._itemArr[(_local_1 - 1)].height) + 4);
                };
                this._itemArr[_local_1].x = this._pos1.x;
                _local_1++;
            };
        }

        private function __bigItemClick(_arg_1:ComposeEvents):void
        {
            var _local_2:ComposeBigItem = (_arg_1.currentTarget as ComposeBigItem);
            this._currentType = _local_2.num;
            this.updateBigitem();
        }

        private function updateBigitem():void
        {
            this.clearItems();
            this.drawItems();
        }

        private function initEvent():void
        {
            ComposeController.instance.model.addEventListener(ComposeEvents.GET_SKILLS_COMPLETE, this.__getSkillsComplete);
        }

        private function clearItems():void
        {
            var _local_1:ComposeBigItem;
            if (((this._itemArr) && (this._itemArr.length > 0)))
            {
                for each (_local_1 in this._itemArr)
                {
                    _local_1.removeEventListener(ComposeEvents.CLICK_BIG_ITEM, this.__bigItemClick);
                    ObjectUtils.disposeObject(_local_1);
                    _local_1 = null;
                };
                this._itemArr = null;
            };
        }

        private function __getSkillsComplete(_arg_1:ComposeEvents):void
        {
            this.updateBigitem();
        }

        private function removeEvents():void
        {
            ComposeController.instance.model.removeEventListener(ComposeEvents.GET_SKILLS_COMPLETE, this.__getSkillsComplete);
        }

        public function dispose():void
        {
            this.removeEvents();
            this.clearItems();
            if (this._itemList)
            {
                ObjectUtils.disposeObject(this._itemList);
                this._itemList = null;
            };
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
                this._bg = null;
            };
        }


    }
}//package store.view.Compose.view

