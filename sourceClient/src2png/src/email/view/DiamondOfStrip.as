// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//email.view.DiamondOfStrip

package email.view
{
    import ddt.data.goods.InventoryItemInfo;

    public class DiamondOfStrip extends DiamondBase 
    {

        public function DiamondOfStrip()
        {
            countTxt.visible = false;
            diamondBg.visible = false;
        }

        override protected function update():void
        {
            var _local_1:*;
            _local_1 = _info.getAnnexByIndex(index);
            if (((_local_1) && (_local_1 is String)))
            {
                _cell.visible = false;
                centerMC.visible = true;
                mouseEnabled = true;
                if (_local_1 == "gold")
                {
                    centerMC.setFrame(3);
                    countTxt.text = String(_info.Gold);
                }
                else
                {
                    if (_local_1 == "money")
                    {
                        centerMC.setFrame(2);
                        countTxt.text = String(_info.Money);
                    }
                    else
                    {
                        if (_local_1 == "bindMoney")
                        {
                            centerMC.setFrame(6);
                            countTxt.text = String(_info.BindMoney);
                        };
                    };
                };
            }
            else
            {
                if (_local_1)
                {
                    _cell.visible = true;
                    centerMC.visible = false;
                    _cell.info = (_local_1 as InventoryItemInfo);
                    mouseEnabled = true;
                }
                else
                {
                    centerMC.visible = true;
                    _cell.visible = false;
                    if (_info.IsRead)
                    {
                        centerMC.setFrame(5);
                    }
                    else
                    {
                        centerMC.setFrame(4);
                    };
                    mouseEnabled = false;
                };
            };
        }

        override public function dispose():void
        {
            super.dispose();
        }


    }
}//package email.view

