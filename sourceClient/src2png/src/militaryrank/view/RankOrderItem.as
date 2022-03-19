// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//militaryrank.view.RankOrderItem

package militaryrank.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import flash.display.Bitmap;
    import ddt.data.ConsortiaInfo;
    import com.pickgliss.ui.text.FilterFrameText;
    import com.pickgliss.ui.ComponentFactory;
    import ddt.utils.PositionUtils;
    import ddt.data.player.PlayerInfo;
    import ddt.manager.LanguageMgr;
    import militaryrank.model.MilitaryLevelModel;
    import ddt.manager.ServerConfigManager;
    import militaryrank.MilitaryRankManager;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class RankOrderItem extends Sprite implements Disposeable 
    {

        private var _itemBG:ScaleFrameImage;
        private var _vline:Bitmap;
        private var _index:int;
        private var _info:ConsortiaInfo;
        private var _selected:Boolean;
        private var _militaryDataTxt:FilterFrameText;
        private var _militaryNameTxt:FilterFrameText;
        private var _icon:MilitaryIcon;
        private var _array:Array;

        public function RankOrderItem(_arg_1:int)
        {
            this._index = _arg_1;
            this.init();
        }

        private function init():void
        {
            this._itemBG = ComponentFactory.Instance.creatComponentByStylename("militaryrank.MemberListItem");
            if (((this._index % 2) == 0))
            {
                this._itemBG.setFrame(2);
            }
            else
            {
                this._itemBG.setFrame(1);
            };
            this._vline = ComponentFactory.Instance.creatBitmap("asset.formTop.Line");
            PositionUtils.setPos(this._vline, "militaryrank.line.pos");
            this._militaryDataTxt = ComponentFactory.Instance.creatComponentByStylename("militaryrank.dataTxt");
            this._militaryNameTxt = ComponentFactory.Instance.creatComponentByStylename("militaryrank.nameTxt");
            this._icon = new MilitaryIcon(new PlayerInfo());
            this._icon.ShowTips = false;
            PositionUtils.setPos(this._icon, "militaryrank.Icon.pos");
            addChild(this._itemBG);
            this._vline.height = 22;
            addChild(this._vline);
            addChild(this._icon);
            addChild(this._militaryDataTxt);
            addChild(this._militaryNameTxt);
            this._array = LanguageMgr.GetTranslation("militaryrank.view.zhanjiList").split(",");
        }

        public function set info(_arg_1:int):void
        {
            var _local_2:MilitaryLevelModel;
            if (_arg_1 == -1)
            {
                this._icon.setCusFrame(16);
                this._militaryNameTxt.text = ServerConfigManager.instance.getMilitaryName()[15];
                this._militaryDataTxt.text = this._array[2];
            }
            else
            {
                if (_arg_1 == -2)
                {
                    this._icon.setCusFrame(15);
                    this._militaryNameTxt.text = ServerConfigManager.instance.getMilitaryName()[14];
                    this._militaryDataTxt.text = this._array[1];
                }
                else
                {
                    if (_arg_1 == -3)
                    {
                        this._icon.setCusFrame(14);
                        this._militaryNameTxt.text = ServerConfigManager.instance.getMilitaryName()[13];
                        this._militaryDataTxt.text = this._array[0];
                    }
                    else
                    {
                        this._icon.setMilitary(_arg_1);
                        _local_2 = MilitaryRankManager.Instance.getMilitaryRankInfo(_arg_1);
                        this._militaryNameTxt.text = _local_2.Name;
                        this._militaryDataTxt.text = ((_local_2.MaxScore == int.MAX_VALUE) ? (_local_2.MinScore + "～") : ((_local_2.MinScore + "～") + (_local_2.MaxScore - 1)));
                    };
                };
            };
        }

        public function set selected(_arg_1:Boolean):void
        {
            if (this._selected == _arg_1)
            {
                return;
            };
            this._selected = _arg_1;
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set light(_arg_1:Boolean):void
        {
            if (this._selected)
            {
                return;
            };
        }

        override public function get height():Number
        {
            if (this._itemBG == null)
            {
                return (0);
            };
            return (this._itemBG.y + this._itemBG.height);
        }

        public function getCellValue():*
        {
            return (this._info);
        }

        public function setCellValue(_arg_1:*):void
        {
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function set isApply(_arg_1:Boolean):void
        {
            if (_arg_1)
            {
                alpha = 0.5;
                mouseChildren = false;
                mouseEnabled = false;
            }
            else
            {
                alpha = 1;
                mouseChildren = true;
                mouseEnabled = true;
            };
        }

        public function dispose():void
        {
            ObjectUtils.disposeAllChildren(this);
            this._itemBG = null;
            this._vline = null;
            this._militaryDataTxt = null;
            this._militaryNameTxt = null;
            this._icon = null;
            if (this.parent)
            {
                this.parent.removeChild(this);
            };
        }


    }
}//package militaryrank.view

