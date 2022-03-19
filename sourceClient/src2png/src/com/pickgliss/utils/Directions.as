// Decompiled by AS3 Sorcerer 6.78
// www.buraks.com/as3sorcerer

//com.pickgliss.utils.Directions

package com.pickgliss.utils
{
    public final class Directions 
    {

        public static const DIRECTION_B:int = 3;
        public static const DIRECTION_BL:int = 6;
        public static const DIRECTION_BR:int = 7;
        public static const DIRECTION_L:int = 1;
        public static const DIRECTION_R:int = 2;
        public static const DIRECTION_T:int = 0;
        public static const DIRECTION_TL:int = 4;
        public static const DIRECTION_TR:int = 5;


        public static function getHorizontalDirection(_arg_1:int):int
        {
            if ((((_arg_1 == DIRECTION_L) || (_arg_1 == DIRECTION_TL)) || (_arg_1 == DIRECTION_BL)))
            {
                return (-1);
            };
            if ((((_arg_1 == DIRECTION_R) || (_arg_1 == DIRECTION_TR)) || (_arg_1 == DIRECTION_BR)))
            {
                return (1);
            };
            return (0);
        }

        public static function getVerticalDirection(_arg_1:int):int
        {
            if ((((_arg_1 == DIRECTION_T) || (_arg_1 == DIRECTION_TL)) || (_arg_1 == DIRECTION_TR)))
            {
                return (-1);
            };
            if ((((_arg_1 == DIRECTION_B) || (_arg_1 == DIRECTION_BL)) || (_arg_1 == DIRECTION_BR)))
            {
                return (1);
            };
            return (0);
        }


    }
}//package com.pickgliss.utils

