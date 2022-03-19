// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//consortion.view.selfConsortia.WeekOfferListItem

package consortion.view.selfConsortia
{
    import flash.display.Sprite;
    import com.pickgliss.ui.controls.cell.IListCell;
    import com.pickgliss.ui.core.Disposeable;
    import flash.display.Bitmap;
    import com.pickgliss.ui.text.FilterFrameText;
    import ddt.data.player.ConsortiaPlayerInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.ui.controls.list.List;
    import flash.display.DisplayObject;
    import com.pickgliss.utils.ObjectUtils;

    public class WeekOfferListItem extends Sprite implements IListCell, Disposeable 
    {

        private var _bg:Bitmap;
        private var _rank:FilterFrameText;
        private var _name:FilterFrameText;
        private var _contribute:FilterFrameText;
        private var _playerInfo:ConsortiaPlayerInfo;

        public function WeekOfferListItem()
        {
            this._bg = ComponentFactory.Instance.creatBitmap("asset.placardAndEvent.weekOfferItemBG");
            this._rank = ComponentFactory.Instance.creatComponentByStylename("eventItem.rank");
            this._name = ComponentFactory.Instance.creatComponentByStylename("eventItem.name");
            this._contribute = ComponentFactory.Instance.creatComponentByStylename("eventItem.contribute");
            addChild(this._bg);
            addChild(this._rank);
            addChild(this._name);
            addChild(this._contribute);
        }

        public function setListCellStatus(_arg_1:List, _arg_2:Boolean, _arg_3:int):void
        {
            var _local_4:int = (_arg_3 + 1);
            if (_local_4 == 1)
            {
                this._rank.text = (_local_4 + "st");
            }
            else
            {
                if (_local_4 == 2)
                {
                    this._rank.text = (_local_4 + "nd");
                }
                else
                {
                    if (_local_4 == 3)
                    {
                        this._rank.text = (_local_4 + "rd");
                    }
                    else
                    {
                        this._rank.text = (_local_4 + "th");
                    };
                };
            };
        }

        public function getCellValue():*
        {
            return (this._playerInfo);
        }

        public function setCellValue(_arg_1:*):void
        {
            this._playerInfo = _arg_1;
            this._name.text = this._playerInfo.NickName;
            this._contribute.text = this._playerInfo.LastWeekRichesOffer.toString();
        }

        public function asDisplayObject():DisplayObject
        {
            return (this);
        }

        public function dispose():void
        {
            if (this._bg)
            {
                ObjectUtils.disposeObject(this._bg);
                this._bg.bitmapData.dispose();
                this._bg.bitmapData = null;
            };
            this._bg = null;
            if (this._rank)
            {
                ObjectUtils.disposeObject(this._rank);
            };
            this._rank = null;
            if (this._name)
            {
                ObjectUtils.disposeObject(this._name);
            };
            this._name = null;
            if (this._contribute)
            {
                ObjectUtils.disposeObject(this._contribute);
            };
            this._contribute = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package consortion.view.selfConsortia

