// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//militaryrank.view.RankView

package militaryrank.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.MutipleImage;
    import flash.display.Bitmap;
    import com.pickgliss.ui.controls.ScrollPanel;
    import com.pickgliss.ui.controls.container.VBox;
    import __AS3__.vec.Vector;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.utils.PositionUtils;
    import ddt.manager.ServerConfigManager;
    import com.pickgliss.utils.ObjectUtils;
    import __AS3__.vec.*;

    public class RankView extends Sprite implements Disposeable 
    {

        private var _bg:MutipleImage;
        private var _junxianBitm:Bitmap;
        private var _zhanjiBitm:Bitmap;
        private var _scroll:ScrollPanel;
        private var _list:VBox;
        private var _items:Vector.<RankOrderItem>;

        public function RankView()
        {
            this.initView();
            this.initItems();
        }

        private function initView():void
        {
            this._items = new Vector.<RankOrderItem>();
            this._bg = ComponentFactory.Instance.creatComponentByStylename("militaryrank.right.listBg");
            addChild(this._bg);
            var _local_1:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("militaryrank.listTitleText");
            PositionUtils.setPos(_local_1, "militaryrank.junxianText.pos");
            _local_1.text = "军衔";
            var _local_2:FilterFrameText = ComponentFactory.Instance.creatComponentByStylename("militaryrank.listTitleText");
            PositionUtils.setPos(_local_2, "militaryrank.zhanjiText.pos");
            _local_2.text = "战绩";
            var _local_3:Bitmap = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
            PositionUtils.setPos(_local_3, "militaryrank.line.pos1");
            addChild(_local_1);
            addChild(_local_2);
            addChild(_local_3);
            this._list = ComponentFactory.Instance.creatComponentByStylename("Military.vboxContainer");
            addChild(this._list);
            this._scroll = ComponentFactory.Instance.creat("militaryrank.Info.RankScroll");
            addChild(this._scroll);
        }

        private function initItems():void
        {
            var _local_7:RankOrderItem;
            var _local_1:RankOrderItem = new RankOrderItem(0);
            _local_1.info = -1;
            this._list.addChild(_local_1);
            this._items.push(_local_1);
            var _local_2:RankOrderItem = new RankOrderItem(1);
            _local_2.info = -2;
            this._list.addChild(_local_2);
            this._items.push(_local_2);
            var _local_3:RankOrderItem = new RankOrderItem(0);
            _local_3.info = -3;
            this._list.addChild(_local_3);
            this._items.push(_local_3);
            var _local_4:int = ServerConfigManager.instance.getMilitaryData().length;
            var _local_5:Array = ServerConfigManager.instance.getMilitaryData();
            var _local_6:int = (_local_4 - 1);
            while (_local_6 >= 0)
            {
                _local_7 = new RankOrderItem((_local_6 + 1));
                _local_7.info = _local_5[_local_6];
                this._list.addChild(_local_7);
                this._items.push(_local_7);
                _local_6--;
            };
            this._scroll.setView(this._list);
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._bg = null;
            this._junxianBitm = null;
            this._zhanjiBitm = null;
            this._scroll = null;
            this._list = null;
            this._items = null;
        }


    }
}//package militaryrank.view

