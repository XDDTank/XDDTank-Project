// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//activity.view.ActivityItem

package activity.view
{
    import flash.display.Sprite;
    import com.pickgliss.ui.core.Disposeable;
    import com.pickgliss.ui.image.ScaleFrameImage;
    import com.pickgliss.ui.text.FilterFrameText;
    import flash.display.MovieClip;
    import activity.data.ActivityInfo;
    import com.pickgliss.ui.ComponentFactory;
    import com.pickgliss.utils.DisplayUtils;
    import com.pickgliss.utils.ClassUtils;
    import activity.ActivityController;
    import com.pickgliss.utils.ObjectUtils;

    public class ActivityItem extends Sprite implements Disposeable 
    {

        protected var _back:ScaleFrameImage;
        protected var _icon:ScaleFrameImage;
        protected var _titleField:FilterFrameText;
        protected var _quanMC:MovieClip;
        protected var _info:ActivityInfo;
        protected var _selected:Boolean = false;

        public function ActivityItem(_arg_1:ActivityInfo)
        {
            this._info = _arg_1;
            buttonMode = true;
            this.initView();
            this.initEvent();
        }

        public function get info():ActivityInfo
        {
            return (this._info);
        }

        public function set info(_arg_1:ActivityInfo):void
        {
            this._info = _arg_1;
        }

        protected function initView():void
        {
            var _local_1:int;
            this._back = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellBg");
            DisplayUtils.setFrame(this._back, ((this._selected) ? 2 : 1));
            addChild(this._back);
            this._titleField = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellTitleText");
            this._titleField.htmlText = ("<b>·</b> " + this._info.ActivityName);
            if (this._titleField.textWidth > 90)
            {
                _local_1 = this._titleField.getCharIndexAtPoint((this._titleField.x + 86), (this._titleField.y + 2));
                if (_local_1 != -1)
                {
                    this._titleField.htmlText = (("<b>·</b> " + this._info.ActivityName.substring(0, _local_1)) + "...");
                };
            };
            addChild(this._titleField);
            this._icon = ComponentFactory.Instance.creatComponentByStylename("ddtcalendar.ActivityCellTitleIcon");
            DisplayUtils.setFrame(this._icon, this.getActivityDispType(this._info.ActivityType));
            addChild(this._icon);
            if ((!(this._quanMC)))
            {
                this._quanMC = ClassUtils.CreatInstance("asset.ddtActivity.MC");
                this._quanMC.mouseChildren = false;
                this._quanMC.mouseEnabled = false;
                this._quanMC.gotoAndPlay(1);
                this._quanMC.x = -3;
                this._quanMC.y = 4;
            };
            addChild(this._quanMC);
            if (ActivityController.instance.checkFinish(this._info))
            {
                this._quanMC.visible = false;
            }
            else
            {
                this._quanMC.visible = true;
            };
        }

        protected function initEvent():void
        {
        }

        protected function getActivityDispType(_arg_1:int):int
        {
            var _local_2:int;
            switch (_arg_1)
            {
                case 1:
                    _local_2 = 1;
                    break;
                case 2:
                    _local_2 = 2;
                    break;
                case 3:
                    _local_2 = 3;
                    break;
                case 4:
                    _local_2 = 4;
                    break;
                case 5:
                    _local_2 = 5;
                    break;
                case 6:
                    _local_2 = 6;
                    break;
                case 0:
                case 7:
                    _local_2 = 7;
                    break;
                case 8:
                    _local_2 = 3;
                    break;
                case 9:
                    _local_2 = 3;
                    break;
                case 10:
                    _local_2 = 1;
                    break;
                default:
                    _local_2 = 6;
            };
            return (_local_2);
        }

        public function get selected():Boolean
        {
            return (this._selected);
        }

        public function set selected(_arg_1:Boolean):void
        {
            if (this._selected == _arg_1)
            {
                return;
            };
            this._selected = _arg_1;
            DisplayUtils.setFrame(this._back, ((this._selected) ? 2 : 1));
            DisplayUtils.setFrame(this._titleField, ((this._selected) ? 2 : 1));
        }

        protected function removeEvent():void
        {
        }

        public function dispose():void
        {
            this.removeEvent();
            ObjectUtils.disposeObject(this._back);
            this._back = null;
            ObjectUtils.disposeObject(this._titleField);
            this._titleField = null;
            ObjectUtils.disposeObject(this._icon);
            this._icon = null;
            if (this._quanMC)
            {
                ObjectUtils.disposeObject(this._quanMC);
            };
            this._quanMC = null;
            if (parent)
            {
                parent.removeChild(this);
            };
        }


    }
}//package activity.view

