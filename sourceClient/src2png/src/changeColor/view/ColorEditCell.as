// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//changeColor.view.ColorEditCell

package changeColor.view
{
    import bagAndInfo.cell.LinkedBagCell;
    import flash.display.Sprite;
    import ddt.manager.SoundManager;
    import ddt.manager.PlayerManager;
    import flash.events.MouseEvent;

    public class ColorEditCell extends LinkedBagCell 
    {

        public function ColorEditCell(_arg_1:Sprite)
        {
            super(_arg_1);
            super.DoubleClickEnabled = false;
        }

        override protected function onMouseClick(_arg_1:MouseEvent):void
        {
            if (this.itemInfo != null)
            {
                SoundManager.instance.play("008");
                if (((_bagCell.itemInfo) && (_bagCell.itemInfo.lock)))
                {
                    if (_bagCell.itemInfo.BagType == 0)
                    {
                        PlayerManager.Instance.Self.Bag.unlockItem(_bagCell.itemInfo);
                    }
                    else
                    {
                        PlayerManager.Instance.Self.PropBag.unlockItem(_bagCell.itemInfo);
                    };
                };
                bagCell.locked = false;
                bagCell = null;
            };
        }

        override protected function onMouseOver(_arg_1:MouseEvent):void
        {
        }

        override protected function onMouseOut(_arg_1:MouseEvent):void
        {
        }


    }
}//package changeColor.view

