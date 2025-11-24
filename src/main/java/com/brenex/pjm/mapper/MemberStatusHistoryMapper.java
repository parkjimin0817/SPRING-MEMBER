package com.brenex.pjm.mapper;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface MemberStatusHistoryMapper {
    int createStatusHistory(@Param("memberNoList")List<Integer> memberNoList, @Param("status")String status,
                            @Param("reason")String reason, @Param("changedBy")int changedBy);
}
