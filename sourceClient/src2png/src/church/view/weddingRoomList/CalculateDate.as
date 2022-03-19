// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//church.view.weddingRoomList.CalculateDate

package church.view.weddingRoomList
{
    import ddt.manager.TimeManager;
    import com.pickgliss.ui.ComponentFactory;
    import flash.geom.Point;
    import ddt.manager.LanguageMgr;
    import platformapi.tencent.DiamondManager;

    public class CalculateDate 
    {


        public static function start(_arg_1:Date, _arg_2:int):Array
        {
            var _local_3:Date = TimeManager.Instance.Now();
            var _local_4:Array = new Array();
            var _local_5:Point = ComponentFactory.Instance.creatCustomObject("church.view.weddingRoomList.pointout");
            _local_5.y = needMoney(_arg_1, _arg_2);
            var _local_6:int = int(((_local_3.valueOf() - _arg_1.valueOf()) / (60 * 60000)));
            if (_local_6 >= 720)
            {
                _local_4[0] = (("<font COLOR='#FFFFFF'>" + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.exceedmounth")) + "</font>");
                _local_4[1] = (("<font COLOR='#FFFFFF'>" + String(_local_5.y)) + "</font>");
            }
            else
            {
                if (((_local_6 >= 24) && (_local_6 < 720)))
                {
                    _local_4[0] = ((("<font COLOR='#FFFFFF'>" + String(int((_local_6 / 24)))) + LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.day")) + "</font>");
                    if (_arg_2 < 3)
                    {
                        _local_4[1] = (("<font COLOR='#FFFFFF'>" + String(_local_5.y)) + "</font>");
                    }
                    else
                    {
                        _local_4[1] = (("<font COLOR='#FFFFFF'>" + String(_local_5.x)) + "</font>");
                    };
                }
                else
                {
                    if (_local_6 < 24)
                    {
                        _local_4[0] = LanguageMgr.GetTranslation("church.weddingRoom.frame.AddWeddingRoomFrame.notenoughday");
                        if (_arg_2 < 3)
                        {
                            _local_4[1] = (("<font COLOR='#FFFFFF'>" + String(_local_5.y)) + "</font>");
                        }
                        else
                        {
                            _local_4[1] = (("<font COLOR='#FFFFFF'>" + String(_local_5.x)) + "</font>");
                        };
                    };
                };
            };
            return (_local_4);
        }

        public static function needMoney(_arg_1:Date, _arg_2:int):int
        {
            var _local_5:int;
            var _local_3:Date = TimeManager.Instance.Now();
            var _local_4:int = int(((_local_3.valueOf() - _arg_1.valueOf()) / (60 * 60000)));
            if (_local_4 >= 720)
            {
                _local_5 = getDivoceMoney2();
            }
            else
            {
                _local_5 = 520;
            };
            if (_arg_2 < 3)
            {
                _local_5 = getDivoceMoney2();
            };
            return (_local_5);
        }

        public static function getDivoceMoney2():int
        {
            if (DiamondManager.instance.isInTencent)
            {
                return (123);
            };
            return (99);
        }


    }
}//package church.view.weddingRoomList

