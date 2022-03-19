// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//tryonSystem.ChooseFrame

package tryonSystem
{
    import com.pickgliss.ui.controls.alert.BaseAlerFrame;
    import com.pickgliss.ui.image.ScaleBitmapImage;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.SimpleTileList;
    import com.pickgliss.ui.vo.AlertInfo;
    import ddt.manager.LanguageMgr;
    import equipretrieve.effect.AnimationControl;
    import ddt.data.goods.InventoryItemInfo;
    import quest.QuestRewardCell;
    import com.pickgliss.ui.image.MovieImage;
    import equipretrieve.effect.GlowFilterAnimation;
    import com.pickgliss.ui.ComponentFactory;
    import flash.events.Event;
    import quest.TaskMainFrame;
    import flash.events.MouseEvent;
    import ddt.manager.SoundManager;
    import com.pickgliss.utils.ObjectUtils;

    public class ChooseFrame extends BaseAlerFrame 
    {

        private var _control:TryonSystemController;
        private var _bg:ScaleBitmapImage;
        private var _cells:Array;
        private var _scroll:ScrollPanel;
        private var _list:SimpleTileList;

        public function ChooseFrame()
        {
            var _local_1:AlertInfo = new AlertInfo(LanguageMgr.GetTranslation("ddt.tryonSystem.title"), "", "", true, false);
            _local_1.submitLabel = LanguageMgr.GetTranslation("ok");
            _local_1.moveEnable = false;
            info = _local_1;
        }

        public function set controller(_arg_1:TryonSystemController):void
        {
            this._control = _arg_1;
            this.initView();
        }

        private function initView():void
        {
            var _local_1:AnimationControl;
            var _local_2:InventoryItemInfo;
            var _local_3:QuestRewardCell;
            var _local_4:MovieImage;
            var _local_5:GlowFilterAnimation;
            this._bg = ComponentFactory.Instance.creatComponentByStylename("ChooseFrame.tryon.chooseItemBgAsset.bg");
            addToContent(this._bg);
            this._list = new SimpleTileList(2);
            this._list.hSpace = 6;
            this._list.vSpace = -5;
            this._scroll = ComponentFactory.Instance.creatComponentByStylename("ddtquest.ChooseFrameList");
            this._scroll.setView(this._list);
            this._scroll.vScrollProxy = ScrollPanel.ON;
            addToContent(this._scroll);
            this._cells = [];
            _local_1 = new AnimationControl();
            _local_1.addEventListener(Event.COMPLETE, this._cellLightComplete);
            for each (_local_2 in this._control.model.items)
            {
                _local_3 = new QuestRewardCell();
                _local_3.opitional = true;
                _local_3.taskType = TaskMainFrame.NORMAL;
                _local_3.info = _local_2;
                _local_3.addEventListener(MouseEvent.CLICK, this.__onclick);
                _local_3.buttonMode = true;
                this._cells.push(_local_3);
                this._list.addChild(_local_3);
                _local_4 = ComponentFactory.Instance.creatComponentByStylename("asset.core.itemShinelight");
                _local_4.movie.play();
                _local_3.addChildAt(_local_4, 1);
                _local_5 = new GlowFilterAnimation();
                _local_5.start(_local_4, false, 16763955, 0, 0);
                _local_5.addMovie(0, 0, 19, 0);
                _local_1.addMovies(_local_5);
            };
            _local_1.startMovie();
        }

        private function _cellLightComplete(_arg_1:Event):void
        {
            var _local_2:int;
            var _local_3:int;
            _arg_1.currentTarget.removeEventListener(Event.COMPLETE, this._cellLightComplete);
            if (this._cells)
            {
                _local_2 = this._cells.length;
                _local_3 = 0;
                while (_local_3 < _local_2)
                {
                    this._cells[_local_3].removeChildAt(1);
                    _local_3++;
                };
            };
        }

        private function __onclick(_arg_1:MouseEvent):void
        {
            var _local_2:QuestRewardCell;
            SoundManager.instance.play("008");
            for each (_local_2 in this._cells)
            {
                _local_2.selected = false;
            };
            this._control.model.selectedItem = QuestRewardCell(_arg_1.currentTarget).info;
            QuestRewardCell(_arg_1.currentTarget).selected = true;
        }

        override public function dispose():void
        {
            var _local_1:QuestRewardCell;
            this._control = null;
            for each (_local_1 in this._cells)
            {
                _local_1.removeEventListener(MouseEvent.CLICK, this.__onclick);
                _local_1.removeChildAt(1);
                _local_1.dispose();
            };
            this._cells = null;
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
            };
            this._bg = null;
            ObjectUtils.disposeObject(this._list);
            this._list = null;
            super.dispose();
        }


    }
}//package tryonSystem

