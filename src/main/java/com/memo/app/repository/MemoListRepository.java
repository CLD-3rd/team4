package com.memo.app.repository;

import com.memo.app.entity.MemoList;
import com.memo.app.entity.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MemoListRepository extends JpaRepository<MemoList, String> {
//    List<MemoList> findByUserUsernoOrderByCreatedAtDesc(Long userno);
    List<MemoList> findByUserOrderByCreatedAtDesc(User user);
}
