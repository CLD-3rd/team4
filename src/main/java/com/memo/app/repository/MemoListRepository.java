package com.memo.app.repository;

import com.memo.app.entity.MemoList;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface MemoListRepository extends JpaRepository<MemoList, String> {
}
